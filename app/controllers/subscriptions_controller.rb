class SubscriptionsController < ApiController
  acts_as_token_authentication_handler_for User, fallback: :exception

  def index
    render json: Subscription.includes(:channel).where(user_id: current_user.id).order('channels.title ASC'),
           include: [:channel]
  end
end
