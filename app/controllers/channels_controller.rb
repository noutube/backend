require 'case_insensitive_hash'
require 'csv'
require 'modules/scrape'

class ChannelsController < ApiController
  before_action :authenticate_user

  serialization_scope :current_user

  def create
    authorize! :create, Subscription
    attributes = params.require(:data).require(:attributes).permit(:api_id, :is_subscribed)
    # get canonical channel ID from URL
    unless scrape = Scrape.scrape('channel', url: attributes[:api_id])
      head :not_found
      return
    end
    channel = Channel.find_or_initialize_by(api_id: scrape['channelId'])
    channel.scrape(scrape)
    channel.save!
    if attributes[:is_subscribed]
      Subscription.find_or_create_by!(user: current_user, channel: channel)
    end
    render json: channel, status: :created
  end

  def index
    authorize! :read, Subscription
    render json: current_user.all_channels
  end

  def update
    authorize! :update, Subscription
    attributes = params.require(:data).require(:attributes).permit(:is_subscribed)
    if attributes[:is_subscribed]
      Subscription.find_or_create_by!(channel_id: params[:id], user: current_user)
    else
      Subscription.find_by(channel_id: params[:id], user: current_user)&.destroy!
    end
    head :no_content
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
      # scraping is slow, especially in a loop, so only do it if we really have to
      channel.scrape unless channel.thumbnail
      channel.save!

      subscription = Subscription.find_or_create_by!(user: current_user, channel: channel)
      subscription_ids << subscription.id
    end

    Subscription.where(user: current_user).where.not(id: subscription_ids).destroy_all
  end
end
