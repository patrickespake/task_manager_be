# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExceptionHandler, type: :controller do
  let(:user) { create(:user) }
  let(:authorization) { "Bearer #{create(:access_token, resource_owner: user).token}" }

  before { request.headers.merge!(Authorization: authorization) }

  controller(ApplicationController) do
    include ExceptionHandler

    def trigger_routing_error
      raise ActionController::RoutingError, "No route matches [GET] '/foo'"
    end

    def trigger_parameter_missing
      params.require(:test)
    end

    def trigger_parse_error
      raise ActionDispatch::Http::Parameters::ParseError, 'Parse error'
    end

    def trigger_record_not_found
      raise ActiveRecord::RecordNotFound
    end

    def trigger_argument_error
      raise ArgumentError, 'Invalid argument'
    end
  end

  before do
    routes.draw do
      get 'trigger_routing_error' => 'anonymous#trigger_routing_error'
      get 'trigger_parameter_missing' => 'anonymous#trigger_parameter_missing'
      get 'trigger_parse_error' => 'anonymous#trigger_parse_error'
      get 'trigger_record_not_found' => 'anonymous#trigger_record_not_found'
      get 'trigger_argument_error' => 'anonymous#trigger_argument_error'
    end
  end

  describe 'rescue_from exceptions' do
    context 'ActionController::RoutingError' do
      it 'responds with not_found status' do
        get :trigger_routing_error
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'ActionController::ParameterMissing' do
      it 'responds with unprocessable_entity status' do
        get :trigger_parameter_missing
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'ActionDispatch::Http::Parameters::ParseError' do
      it 'responds with bad_request status' do
        get :trigger_parse_error
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'ActiveRecord::RecordNotFound' do
      it 'responds with not_found status' do
        get :trigger_record_not_found
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'ArgumentError' do
      it 'responds with bad_request status' do
        get :trigger_argument_error
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
