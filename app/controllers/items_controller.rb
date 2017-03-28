class ItemsController < ApiController
  acts_as_token_authentication_handler_for User

  def index
    render json: Item.includes(:video).joins(:subscription).where(subscriptions: { user_id: current_user.id }).order('videos.published_at DESC'),
           include: [:video]
  end

  def update
    item = Item.find(params[:id])
    authorize! :update, item
    if item.update(params[:data][:attributes].permit(:state))
      head :no_content
    else
      render json: item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    item = Item.find(params[:id])
    authorize! :destroy, item
    item.destroy!
    head :no_content
  end
end
