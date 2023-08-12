# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ExceptionHandler
  before_action :doorkeeper_authorize!

  respond_to :json

  def not_found
    raise ActionController::RoutingError, request.path
  end

  private

  # Helper method to access the current user from the token
  def current_user
    @current_user ||= User.find_by(id: doorkeeper_token&.public_send(:resource_owner_id))
  end
end
