# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Pundit::Authorization
  include ActionController::MimeResponds

  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from Pundit::NotAuthorizedError, with: :render_forbidden

  def render_success(data:, message: 'Success', status: :ok)
    render json: { success: true, data: serialize(data), message: }, status: status
  end

  def render_error(errors:, message: 'Error', status: :unprocessable_entity)
    render json: { success: false, errors: Array(errors), message: }, status: status
  end

  private

  def serialize(resource)
    if resource.respond_to?(:serializable_hash)
      resource.serializable_hash
    elsif resource.respond_to?(:as_json)
      resource.as_json
    else
      resource
    end
  end

  def authenticate_user!
    return if current_user

    render_error(errors: ['Unauthorized'], message: 'Unauthorized', status: :unauthorized)
  end

  def current_user
    return @current_user if defined?(@current_user)

    if defined?(Warden::JWTAuth)
      @current_user = WardenAuthentication::Decoder.call(request)&.user
    end

    @current_user
  end

  def render_not_found(exception)
    render_error(errors: [exception.message], message: 'Not Found', status: :not_found)
  end

  def render_forbidden(exception)
    render_error(errors: [exception.message], message: 'Forbidden', status: :forbidden)
  end
end
