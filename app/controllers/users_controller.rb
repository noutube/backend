class UsersController < ApiController
  before_action :authenticate_user, except: [:create]

  def create
    authorize! :create, User
    attributes = params.require(:data).require(:attributes).permit(:email, :password)
    user = User.new(attributes)
    if user.save
      render json: user, status: :created
    else
      render json: user.errors, status: :bad_request
    end
  end

  def show
    authorize! :read, User
    user = User.find(params[:id])
    authorize! :read, user
    render json: user
  end

  def update
    authorize! :update, User
    user = User.find(params[:id])
    authorize! :update, user
    attributes = params.require(:data).require(:attributes).permit(:password)
    if user.update(attributes)
      head :no_content
    else
      render json: user.errors, status: :bad_request
    end
  end

  def destroy
    authorize! :destroy, User
    user = User.find(params[:id])
    authorize! :destroy, user
    user.destroy!
    head :no_content
  end
end
