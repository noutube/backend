class ItemsController < ApiController
  acts_as_token_authentication_handler_for User

  def index
    render json: Item.includes(:video).joins(:subscription).where(subscriptions: { user_id: current_user.id }).order('videos.published_at DESC'),
           include: [:video]
  end

  def later
    item = Item.find(params[:item_id])
    authorize! :update, item
    item.state = :state_later
    item.save!
    render nothing: true
  end

  def destroy
    item = Item.find(params[:item_id])
    authorize! :destroy, item
    item.destroy!
    render nothing: true
  end
end