class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions, id: false do |t|
      t.uuid :id, primary_key: true, null: false

      t.uuid :user_id, null: false
      t.uuid :channel_id, null: false

      t.timestamps null: false
    end

    add_index :subscriptions, :user_id
    add_index :subscriptions, :channel_id
    add_index :subscriptions, [ :user_id, :channel_id ]
  end
end
