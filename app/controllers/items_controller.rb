class ItemsController < ApiController
  acts_as_token_authentication_handler_for User, fallback: :exception

  def index
    authorize! :read, Item
    render json: collection,
           include: [:video]
  end

  def update
    authorize! :update, Item
    item = Item.find(params[:id])
    authorize! :update, item
    if item.update(params[:data][:attributes].permit(:state))
      head :no_content
    else
      render json: item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, Item
    item = Item.find(params[:id])
    authorize! :destroy, item
    item.destroy!
    head :no_content
  end

  private

  def collection
    Item.includes(:video)
        .joins(:subscription)
        .accessible_by(current_ability)
        .where(subscriptions: { user_id: current_user.id })
  end
end
