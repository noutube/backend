class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos, id: false do |t|
      t.uuid :id, primary_key: true, null: false
      t.string :api_id, null: false

      t.uuid :channel_id, null: false
      t.string :title, null: false
      t.string :thumbnail, null: false
      t.integer :duration, default: 0, null: false
      t.datetime :published_at, null: false

      t.timestamps null: false
    end

    add_index :videos, :api_id
    add_index :videos, :channel_id
  end
end
