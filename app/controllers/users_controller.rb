class UsersController < ApiController
  acts_as_token_authentication_handler_for User, fallback: :exception

  def me
    render json: current_user
  end
end
