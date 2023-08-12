# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActionController::RoutingError, with: :path_not_found_exception
    rescue_from ActionController::ParameterMissing, with: :parameter_missing
    rescue_from ActionDispatch::Http::Parameters::ParseError, with: :general_exception
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ArgumentError, with: :general_exception
  end

  private

  def parameter_missing(exception)
    render json: ::ErrorSerializer.new(
      custom_errors: [source: exception.param, detail: I18n.t('errors.parameter_missing', param: exception.param)],
    ).serialized_json, status: :unprocessable_entity
  end

  def general_exception(exception)
    render json: ::ErrorSerializer.new(
      custom_errors: [source: '', detail: exception.to_s],
    ).serialized_json, status: :bad_request
  end

  def path_not_found_exception(exception)
    render json: ::ErrorSerializer.new(
      custom_errors: [source: exception, detail: I18n.t('errors.path_not_found', path: exception)],
    ).serialized_json, status: :not_found
  end

  def record_not_found
    render json: ::ErrorSerializer.new(
      nil,
      custom_errors: [{
        source: '', detail: ResponseCode::CODES[:general][:not_found],
      }],
    ), status: :not_found
  end
end
