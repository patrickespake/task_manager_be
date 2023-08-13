# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let!(:user) { create(:user) }
  let(:application) { create(:application) }
  let(:token) { create(:access_token, resource_owner_id: user.id, application:) }

  before { request.headers['Authorization'] = "Bearer #{token.token}" }

  describe 'GET #show' do
    context 'when the user is authenticated' do
      it 'returns the current user' do
        get :show, format: :json
        parsed_response = JSON.parse(response.body)

        expect(response).to have_http_status(:success)
        expect(parsed_response['data']['attributes']['email']).to eq(user.email)
        expect(parsed_response['data']['attributes']['name']).to eq(user.name)
      end
    end

    context 'when the token is not valid' do
      before { request.headers['Authorization'] = 'Bearer invalid_token' }

      it 'returns an authentication error' do
        get :show, format: :json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
