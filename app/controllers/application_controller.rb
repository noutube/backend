class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def new_session_path(scope)
    new_user_session_path
  end

  def current_ability
    @current_ability ||= ::Ability.new(current_user)
  end

  def force_trailing_slash
    unless request.env['REQUEST_URI'].match(/[^\?]+/).to_s.last == '/'
      redirect_to url_for(params.merge(trailing_slash: true)), status: 301
    end
  end
end
