class CreateVideos < ActiveRecord::Migration[4.2]
  def change
    create_table :videos, id: false do |t|
      t.integer :id, primary_key: true, null: false
      t.string :api_id, null: false

      t.integer :channel_id, null: false
      t.string :title, null: false
      t.string :thumbnail, null: false
      t.integer :duration, default: 0, null: false
      t.datetime :published_at, null: false

      t.timestamps null: false
    end

    add_index :videos, :id, unique: true
    add_index :videos, :api_id, unique: true
    add_index :videos, :channel_id
  end
end
