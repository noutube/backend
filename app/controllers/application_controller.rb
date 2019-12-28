class ApplicationController < ActionController::API
  attr_reader :current_user

  NotAuthorizedError = Class.new(StandardError)
  rescue_from NotAuthorizedError do
    head :unauthorized
  end

  def authenticate_user
    self.current_user = User.find_by(email: request.headers['X-User-Email'])
    raise NotAuthorizedError unless current_user && current_user.authentication_token == request.headers['X-User-Token']
  end

  def current_ability
    @current_ability ||= ::Ability.new(current_user)
  end

  private
    attr_writer :current_user
end
