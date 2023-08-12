# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'oauth', type: :request do
  path '/api/v1/oauth/token' do
    post('token operations') do
      tags 'Oauth'
      description 'Endpoint for token creation (grant_type=password) and refresh (grant_type=refresh_token).'
      consumes 'application/json'
      produces 'application/json'
      let(:application) { create :application }
      let!(:user) { create :user }

      let(:params) do
        {
          grant_type: 'password',
          client_id: application.uid,
          client_secret: application.secret,
          email: user.email,
          password: 'Pa$$w0rd',
        }
      end

      parameter name: :params,
                in: :body,
                required: true,
                type: :object,
                schema: {
                  type: :object,
                  properties: {
                    grant_type: {
                      type: :enum, default: 'password', values: %w[password refresh_token],
                      description: 'Use "password" for new token and "refresh_token" for refreshing an existing token.',
                    },
                    client_id: { type: :string },
                    client_secret: { type: :string },
                    email: { type: :string, description: 'Required only when grant_type = password.' },
                    password: { type: :string, description: 'Required only when grant_type = password.' },
                    refresh_token: { type: :string, description: 'Required only when grant_type = refresh_token.' },
                  },
                }

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 access_token: { type: :string },
                 token_type: { type: :string, default: 'Bearer' },
                 expires_in: { type: :integer, description: 'token expiration in seconds', default: 7200 },
                 refresh_token: { type: :string },
                 created_at: { type: :integer, example: '1691852188' },
               }

        run_test! do |response|
          response_body = JSON.parse(response.body)

          expect(response_body).to include('access_token')
          expect(response_body).to include('token_type')
          expect(response_body).to include('refresh_token')
          expect(response_body).to include('expires_in')
          expect(response_body).to include('created_at')
        end
      end

      response(400, 'bad request') do
        schema '$ref' => '#/components/schemas/ErrorObject'
        let(:params) do
          {
            grant_type: 'invalid grant type',
            client_id: application.uid,
            client_secret: application.secret,
            email: user.email,
            password: 'Pa$$w0rd',
          }
        end

        run_test! do |response|
          response = JSON.parse(response.body)
          expect(response['errors']).to_not(be_empty)
        end
      end
    end
  end
end
