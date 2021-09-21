require 'csv'

class SubscriptionsController < ApiController
  before_action :authenticate_user

  def index
    authorize! :read, Subscription
    render json: collection,
           include: [:channel]
  end

  def takeout
    subscription_ids = []
    CSV.parse(request.body.string.force_encoding(Encoding::UTF_8), headers: true, skip_blanks: true).each do |row|
      channel = Channel.find_or_initialize_by(api_id: row['Channel ID'])
      channel.title = row['Channel title']
      channel.scrape
      channel.checked_at = DateTime.current if channel.new_record?
      channel.save!

      subscription = Subscription.find_or_create_by!(user: current_user, channel: channel)
      subscription_ids << subscription.id
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
