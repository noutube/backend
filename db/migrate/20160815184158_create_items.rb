class CreateItems < ActiveRecord::Migration[4.2]
  def change
    create_table :items, id: false do |t|
      t.integer :id, primary_key: true, null: false

      t.integer :subscription_id, null: false
      t.integer :video_id, null: false
      t.integer :state, null: false, default: 0

      t.timestamps null: false
    end

    add_index :items, :id, unique: true
    add_index :items, :subscription_id
    add_index :items, :video_id
  end
end
