class ItemsController < ApiController
  before_action :authenticate_user

  def index
    authorize! :read, Item
    render json: collection,
           include: [:video]
  end

  def update
    authorize! :update, Item
    item = Item.find(params[:id])
    authorize! :update, item
    attributes = params.require(:data).require(:attributes).permit(:state)
    if item.update(attributes)
      head :no_content
    else
      render json: item.errors, status: :bad_request
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
