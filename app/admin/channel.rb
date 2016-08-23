ActiveAdmin.register Channel do
  menu priority: 3

  index do
    column :title
    column 'API ID', sortable: :api_id do |channel| channel.api_id end
    column :checked_at do |video| span time_ago_in_words(video.checked_at) + ' ago', title: video.checked_at end
    actions
  end

  config.sort_order = 'title_asc'

  filter :title
  filter :api_id, label: 'API ID'
  filter :users_email, as: :string
end
