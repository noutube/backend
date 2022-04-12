class UsersController < ApiController
  before_action :authenticate_user, except: [:create]

  def create
    authorize! :create, User
    attributes = ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:email, :password])
    user = User.new(attributes)
    if user.save
      render json: user, status: :created
    else
      render json: user, status: :unprocessable_entity,
             serializer: ActiveModel::Serializer::ErrorSerializer
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
    attributes = ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:password])
    if user.update(attributes)
      head :no_content
    else
      render json: user, status: :unprocessable_entity,
             serializer: ActiveModel::Serializer::ErrorSerializer
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
