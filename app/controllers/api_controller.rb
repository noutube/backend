class ApiController < ApplicationController
  respond_to :json
  before_action :set_default_request_format

  def set_default_request_format
    request.format = :json unless params[:format]
  end

  def current_ability
    @current_ability ||= ::Ability.new(current_user)
  end
end
