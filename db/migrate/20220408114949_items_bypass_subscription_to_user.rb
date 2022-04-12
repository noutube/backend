class ItemsBypassSubscriptionToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :user_id, :integer
    execute 'UPDATE items SET user_id = subscriptions.user_id FROM subscriptions WHERE items.subscription_id = subscriptions.id'
    change_column_null :items, :user_id, false
    add_index :items, :user_id
    remove_column :items, :subscription_id, :integer, null: false
  end
end
