class UsersController < ApiController
  before_action :authenticate_user

  def show
    authorize! :read, User
    user = User.find(params[:id])
    authorize! :read, user
    render json: current_user
  end

  def destroy
    authorize! :destroy, User
    user = User.find(params[:id])
    authorize! :destroy, user
    user.destroy!
    head :no_content
  end
end
