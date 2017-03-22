class SubscriptionsController < ApplicationController
  acts_as_token_authentication_handler_for User

  respond_to :json

  def index
    respond_with(Subscription.includes(:channel).where(user_id: current_user.id).order('channels.title ASC'))
  end
end
