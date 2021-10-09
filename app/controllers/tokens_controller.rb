require 'modules/auth'

class TokensController < ApiController
  before_action :authenticate_user, only: [:valid]

  def create
    user = User.find_by(email: params[:email])
    raise NotAuthorizedError unless user&.authenticate(params[:password])

    token = Auth.encode({ id: user.id })
    render json: { token: token }
  end

  def valid
    head :ok
  end
end
