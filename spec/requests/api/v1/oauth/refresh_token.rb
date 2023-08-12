# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'oauth/refresh_token', type: :request do
  path '/api/v1/oauth/token' do
    post('refresh token') do
      tags 'Oauth'
      description 'Refresh an existing token'
      consumes 'application/json'
      produces 'application/json'
      let(:application) { create :application }
      let!(:user) { create :user }
      let(:refresh_token) { '908204427cbdbc19abfd653b5635552e23b8740bf22ddf219a24e063065fa3d4' }
      let!(:access_token) do
        Doorkeeper::AccessToken.create(
          application:,
          resource_owner: user,
          refresh_token:,
          expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
          scopes: '',
        )
      end

      let(:params) do
        {
          grant_type: 'refresh_token',
          client_id: application.uid,
          client_secret: application.secret,
          refresh_token:,
        }
      end

      parameter name: :params,
                in: :body,
                required: true,
                type: :object,
                schema: {
                  type: :object,
                  properties: {
                    grant_type: { type: :enum, default: 'refresh_token', values: %w[password refresh_token] },
                    client_id: { type: :string },
                    client_secret: { type: :string },
                    refresh_token: { type: :string },
                  },
                }

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 access_token: { type: :string },
                 token_type: { type: :string, default: 'Bearer' },
                 expires_in: { type: :integer, description: 'token expiration in seconds', default: 7200 },
                 refresh_token: { type: :string },
                 created_at: { type: :integer, example: '1691856540' },
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
            grant_type: 'refresh_token',
            client_id: application.uid,
            client_secret: application.secret,
            refresh_token: 'invalid refresh token',
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
