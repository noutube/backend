require 'modules/scrape'

class VideosController < ApiController
  before_action :authenticate_user

  serialization_scope :current_user

  def create
    authorize! :create, Item
    attributes = ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:'api-id'])
    # get canonical video ID from URL
    unless scrape = Scrape.scrape('video', url: attributes[:api_id])
      head :not_found
      return
    end
    # find channel, or create if missing
    channel = Channel.find_or_initialize_by(api_id: scrape['channelId'])
    if channel.new_record?
      channel.scrape
      channel.save!
    end
    # find video, or create if missing
    video = Video.find_or_initialize_by(api_id: scrape['videoId'], channel: channel)
    video.scrape(scrape)
    video.save!
    # create item just for current user
    item = Item.find_or_initialize_by(user: current_user, video: video)
    item.state = :later
    item.save!
    render json: video, status: :created
  end

  def index
    authorize! :read, Item
    render json: current_user.videos
  end

  def update
    authorize! :update, Item
    item = Item.find_by!(video_id: params[:id], user: current_user)
    authorize! :update, item
    attributes = ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:state])
    if item.update(attributes)
      head :no_content
    else
      render json: item, status: :unprocessable_entity,
             serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  def destroy
    authorize! :destroy, Item
    item = Item.find_by!(video_id: params[:id], user: current_user)
    authorize! :destroy, item
    item.destroy!

    # if this was the last video this user had for this channel,
    # and the user is not subscribed to the channel,
    # pretend the channel no longer exists
    unless item.channel.items.where(user: current_user).exists? || Subscription.where(channel: item.channel, user: current_user).exists?
      item.channel.broadcast_destroy(current_user)
    end

    head :no_content
  end
end
