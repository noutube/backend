class AuthController < ApplicationController
  before_action :authenticate_user, only: [:restore]

  def new
    user = User.find_by(email: params[:email])

    raise NotAuthorizedError unless user&.authenticate(params[:password])

    render json: user,
           serializer: UserAuthSerializer
  end

  def restore
    render json: current_user,
           serializer: UserAuthSerializer
  end
end
