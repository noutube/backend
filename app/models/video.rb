# == Schema Information
#
# Table name: videos
#
#  id              :integer          not null, primary key
#  api_id          :string           not null
#  channel_id      :integer          not null
#  title           :string           not null
#  duration        :integer          default(0), not null
#  published_at    :datetime         not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  is_live         :boolean          default(FALSE), not null
#  is_live_content :boolean          default(FALSE), not null
#  is_upcoming     :boolean          default(FALSE), not null
#  scheduled_at    :datetime
#  visibility      :enum             default("visible"), not null
#
# Indexes
#
#  index_videos_on_api_id      (api_id) UNIQUE
#  index_videos_on_channel_id  (channel_id)
#  index_videos_on_id          (id) UNIQUE
#

require 'modules/scrape'

class Video < ApplicationRecord
  belongs_to :channel
  has_many :items, dependent: :destroy
  # convenience
  has_many :users, through: :items

  validates :api_id, presence: true
  validates :title, presence: true

  after_update do
    users.each do |user|
      broadcast_push(user)
    end
  end

  def thumbnail
    "https://i.ytimg.com/vi/#{api_id}/mqdefault.jpg"
  end

  def scrape(body = nil)
    return unless body = Scrape.scrape('video', videoId: api_id) unless body

    unless body['visible']
      self.visibility = body['reason']
      return
    end

    self.duration = body['duration']
    self.is_live = body['isLive']
    self.is_live_content = body['isLiveContent']
    self.is_upcoming = body['isUpcoming']
    if body['publishedDate'] && !published_at # leave alone if set
      self.published_at = DateTime.parse(body['publishedDate'])
    end
    if body['scheduledAt']
      self.scheduled_at = Time.at(body['scheduledAt'].to_i).to_datetime
    elsif self.is_live_content # don't clear for premieres
      self.scheduled_at = nil
    end
    self.title = body['title']
  end

  def expired_live_content?
    is_live_content && is_upcoming && scheduled_at.nil?
  end

  def broadcast_push(user)
    payload = ActiveModelSerializers::SerializableResource.new \
      self,
      scope: user,
      include: [:channel]
    FeedChannel.broadcast_to \
      user,
      action: :push,
      payload: payload
  end

  def broadcast_destroy(user)
    FeedChannel.broadcast_to \
      user,
      action: :destroy,
      type: :video,
      id: id
  end
end
