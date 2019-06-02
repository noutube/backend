class SubscriptionsController < ApiController
  acts_as_token_authentication_handler_for User, fallback: :exception

  def index
    authorize! :read, Subscription
    render json: collection,
           include: [:channel]
  end

  private

  def collection
    Subscription.includes(:channel)
                .accessible_by(current_ability)
                .where(user_id: current_user.id)
  end
end
