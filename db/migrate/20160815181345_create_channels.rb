class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels, id: false do |t|
      t.uuid :id, primary_key: true, null: false
      t.string :api_id, null: false

      t.string :title, null: false
      t.string :thumbnail, null: false
      t.string :uploads_id, default: '', null: false
      t.datetime :checked_at, null: false

      t.timestamps null: false
    end

    add_index :channels, :api_id
  end
end
