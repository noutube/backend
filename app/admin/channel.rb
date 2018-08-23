ActiveAdmin.register Channel do
  menu priority: 3

  permit_params :title, :thumbnail, :checked_at

  index do
    column :thumbnail do |channel|
      image_tag channel.thumbnail
    end
    column :title do |channel|
      link_to channel.title, "https://youtube.com/channel/#{channel.api_id}"
    end
    column :checked_at do |channel|
      span time_ago_in_words(channel.checked_at) + ' ago', title: channel.checked_at
    end
    column :created_at
    column :updated_at
    actions
  end

  config.sort_order = 'title_asc'

  filter :title
end
