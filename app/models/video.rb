# == Schema Information
#
# Table name: videos
#
#  api_id          :string           not null
#  title           :string           not null
#  duration        :integer          default(0), not null
#  published_at    :datetime         not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  is_live         :boolean          default(FALSE), not null
#  is_live_content :boolean          default(FALSE), not null
#  is_upcoming     :boolean          default(FALSE), not null
#  scheduled_at    :datetime
#  id              :uuid             not null, primary key
#  channel_id      :uuid             not null
#
# Indexes
#
#  index_videos_on_api_id      (api_id) UNIQUE
#  index_videos_on_channel_id  (channel_id)
#  index_videos_on_id          (id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (channel_id => channels.id)
#

require 'net/http'

class Video < ApplicationRecord
  belongs_to :channel
  has_many :items, dependent: :destroy
  # convenience
  has_many :subscriptions, through: :items
  has_many :users, through: :items

  validates :api_id, presence: true
  validates :title, presence: true

  after_create do
    channel.users.each do |user|
      Item.find_or_create_by(subscription: Subscription.find_by(user: user, channel: channel), video: self)
    end
  end

  after_update do
    items.each(&:broadcast_update)
  end

  def thumbnail
    "https://i.ytimg.com/vi/#{api_id}/mqdefault.jpg"
  end

  def scrape
    return unless duration.zero?
    response = Net::HTTP.get_response(URI("https://scrape.noutu.be/video?token=#{ENV['SCRAPE_TOKEN']}&videoId=#{api_id}"))
    return unless response.code == '200'
    body = JSON.parse(response.body)
    self.duration = body['duration']
    self.is_live = body['isLive']
    self.is_live_content = body['isLiveContent']
    self.is_upcoming = body['isUpcoming']
    if body['scheduledAt']
      self.scheduled_at = Time.at(body['scheduledAt'].to_i).to_datetime
    elsif self.is_live_content # don't clear for premieres
      self.scheduled_at = nil
    end
  end

  def expired_live_content?
    is_live_content && is_upcoming && scheduled_at.nil?
  end
end
