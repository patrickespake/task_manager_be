# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  let(:user) { create(:user) }
  let(:authorization) { "Bearer #{create(:access_token, resource_owner: user).token}" }

  describe '#current_user' do
    controller do
      def index
        render json: { user_id: current_user&.id }
      end
    end

    context 'when token is valid' do
      before { request.headers.merge!(Authorization: authorization) }

      it 'returns the user from the token' do
        get :index
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['user_id']).to eq(user.id)
      end
    end

    context 'when token is invalid' do
      before { request.headers.merge!(Authorization: 'Bearer INVALID') }

      it 'returns a 401 status code' do
        get :index
        expect(response.status).to eq(401)
      end

      it 'indicates the token is invalid in the header' do
        get :index
        expect(response.headers['WWW-Authenticate']).to include('error="invalid_token"')
      end
    end
  end
end
