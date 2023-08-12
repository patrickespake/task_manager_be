# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Routes', type: :routing do
  it 'routes to Rswag::Ui::Engine' do
    expect(get: '/api-docs').to be_routable
  end

  it 'routes to Rswag::Api::Engine' do
    expect(get: '/api-docs').to be_routable
  end

  it 'routes to user#show' do
    expect(get: '/api/v1/user').to route_to(controller: 'api/v1/users', action: 'show', format: :json)
  end

  it 'routes to not_found for unmatched routes' do
    expect(get: '/random_route').to route_to(
      controller: 'application',
      action: 'not_found',
      unmatched: 'random_route',
    )
  end
end
