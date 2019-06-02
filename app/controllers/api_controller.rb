class ApiController < ApplicationController
  NotAuthorizedError = Class.new(StandardError)

  rescue_from NotAuthorizedError do
    head :unauthorized
  end

  before_action :set_default_request_format

  def set_default_request_format
    request.format = :json unless params[:format]
  end

  def authenticate_user
    @current_user = User.find_by(email: request.headers['X-User-Email'])
    raise NotAuthorizedError unless current_user && current_user.authentication_token == request.headers['X-User-Token']
  end

  def current_ability
    @current_ability ||= ::Ability.new(current_user)
  end

  def current_user
    @current_user
  end
end
