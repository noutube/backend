require 'modules/auth'

class ApplicationController < ActionController::API
  attr_reader :current_user

  NotAuthorizedError = Class.new(StandardError)
  rescue_from NotAuthorizedError do
    head :unauthorized
  end

  def authenticate_user
    header = request.headers['Authorization'].split
    raise NotAuthorizedError unless header[0] == 'Bearer' && header.length == 2
    begin
      payload = Auth.decode(header[1])
    rescue
      raise NotAuthorizedError
    end
    self.current_user = User.find(payload['id'])
    raise NotAuthorizedError unless current_user
  end

  def current_ability
    @current_ability ||= ::Ability.new(current_user)
  end

  private
    attr_writer :current_user
end
