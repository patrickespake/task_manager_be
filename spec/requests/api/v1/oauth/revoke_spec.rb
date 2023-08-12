# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'oauth', type: :request do
  path '/api/v1/oauth/revoke' do
    post('revoke an existing token') do
      tags 'Oauth'
      description 'Revoke an existing token'
      consumes 'application/json'
      produces 'application/json'
      let(:application) { create :application }
      let!(:user) { create :user }
      let!(:access_token) { create(:access_token, application:, resource_owner: user) }

      let(:params) { { token: access_token.token, client_id: application.uid, client_secret: application.secret } }

      parameter name: :params,
                in: :body,
                required: true,
                type: :object,
                schema: {
                  type: :object,
                  properties: {
                    token: { type: :string },
                    client_id: { type: :string },
                    client_secret: { type: :string },
                  },
                }

      response(200, 'successful') do
        schema type: :object, properties: {}

        run_test!
      end
    end
  end
end
