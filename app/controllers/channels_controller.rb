require 'case_insensitive_hash'
require 'csv'

class ChannelsController < ApiController
  before_action :authenticate_user

  serialization_scope :current_user

  def index
    authorize! :read, Subscription
    render json: current_user.channels
  end

  def takeout
    authorize! :takeout, Subscription

    subscription_ids = []
    CSV.parse(request.body.string.force_encoding(Encoding::UTF_8), headers: true, skip_blanks: true).each do |row|
      # CSV columns are inconsistently capitalised between users, for some reason
      # e.g. Channel ID vs Channel Id, Channel title vs Channel Title
      data = CaseInsensitiveHash.new(row)
      channel = Channel.find_or_initialize_by(api_id: data['channel id'])
      channel.title = data['channel title']
      channel.scrape
      channel.save!

      subscription = Subscription.find_or_create_by!(user: current_user, channel: channel)
      subscription_ids << subscription.id
    end

    Subscription.where(user: current_user).where.not(id: subscription_ids).destroy_all
  end
end
