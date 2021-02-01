class AddScrapeToVideos < ActiveRecord::Migration[6.0]
  def change
    add_column :videos, :is_live, :boolean, null: false, default: false
    add_column :videos, :is_live_content, :boolean, null: false, default: false
    add_column :videos, :is_upcoming, :boolean, null: false, default: false
    add_column :videos, :scheduled_at, :datetime
  end
end
