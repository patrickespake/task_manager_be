# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'User', type: :request do
  path '/api/v1/user' do
    get('get user') do
      tags 'User'
      description 'Get currently signed in user'
      consumes 'application/json'
      produces 'application/json'

      security [Bearer: {}]
      parameter name: :authorization, in: :header
      let(:user) { create :user }
      let(:authorization) { "Bearer #{create(:access_token, resource_owner: user).token}" }

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :string, format: :uuid },
                     type: { type: :string, default: 'user' },
                     attributes: {
                       type: :object,
                       '$ref' => '#/components/schemas/User',
                     },
                   },
                 },
               }

        run_test!
      end

      response(401, 'unauthorized') do
        let!(:authorization) { 'bad auth key' }

        run_test! { |response| expect(response.code).to eq('401') }
      end
    end
  end
end
