ActiveAdmin.register Video do
  menu priority: 4

  controller do
    def scoped_collection
      super.includes :channel
    end
  end

  index do
    column :title
    column 'API ID', sortable: :api_id do |video| video.api_id end
    column :channel, sortable: 'channel.title'
    column :duration do |video| span Time.at(video.duration).utc.strftime('%H:%M:%S'), title: video.duration end
    column :published_at do |video| span time_ago_in_words(video.published_at) + ' ago', title: video.published_at end
    actions
  end

  config.sort_order = 'published_at_desc'

  filter :title
  filter :api_id
  filter :channel_title, as: :string
end
