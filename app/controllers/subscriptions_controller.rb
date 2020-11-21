class SubscriptionsController < ApiController
  before_action :authenticate_user

  def index
    authorize! :read, Subscription
    render json: collection,
           include: [:channel]
  end

  def takeout
    subscription_jsons = JSON.parse(request.body.string)
    subscription_ids = subscription_jsons.map do |subscription_json|
      channel = Channel.find_or_initialize_by(api_id: subscription_json.dig('snippet', 'resourceId', 'channelId'))
      channel.title = subscription_json.dig('snippet', 'title')
      channel.thumbnail = subscription_json.dig('snippet', 'thumbnails', 'default', 'url')
      channel.fetch_thumbnail
      channel.checked_at = DateTime.current if channel.new_record?
      channel.save!

      subscription = Subscription.find_or_create_by!(user: current_user, channel: channel)
      subscription.id
    end

    Subscription.where(user: current_user).where.not(id: subscription_ids).destroy_all
  end

  private
    def collection
      Subscription.includes(:channel)
                  .accessible_by(current_ability)
                  .where(user_id: current_user.id)
    end
end
