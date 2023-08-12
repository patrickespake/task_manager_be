# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  
  scope :api do
    scope :v1 do
      use_doorkeeper { skip_controllers :authorizations, :applications, :authorized_applications, :token_info }
    end
  end

  namespace :api, format: :json, defaults: { format: :json } do
    namespace :v1 do
      resource :user, only: %i[show]
    end
  end

  match '*unmatched', to: 'application#not_found', via: :all
end
