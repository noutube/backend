class VideosController < ApiController
  before_action :authenticate_user

  serialization_scope :current_user

  def index
    authorize! :read, Item
    render json: current_user.videos
  end

  def update
    authorize! :update, Item
    item = Item.find_by!(video_id: params[:id], user: current_user)
    authorize! :update, item
    attributes = params.require(:data).require(:attributes).permit(:state)
    if item.update(attributes)
      head :no_content
    else
      render json: item, status: :unprocessable_entity,
             serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  def destroy
    authorize! :destroy, Item
    item = Item.find_by!(video_id: params[:id], user: current_user)
    authorize! :destroy, item
    item.destroy!
    head :no_content
  end
end
