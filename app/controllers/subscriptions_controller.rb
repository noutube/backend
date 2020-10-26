class SubscriptionsController < ApiController
  before_action :authenticate_user

  def index
    authorize! :read, Subscription
    render json: collection,
           include: [:channel]
  end

  def opml
    subscription_xmls = Hash.from_xml(request.body.read).dig('opml', 'body', 'outline', 'outline')
    subscription_ids = subscription_xmls.map do |subscription_xml|
      channel = Channel.find_or_initialize_by(api_id: subscription_xml['xmlUrl'].last(24))
      channel.title = subscription_xml['title']
      # TODO fetch thumbnail
      channel.thumbnail = '' unless channel.thumbnail
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
