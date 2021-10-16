class SwitchBackToUuids < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'uuid-ossp'

    add_column :channels,      :uuid, :uuid, null: false, default: 'uuid_generate_v4()'
    add_column :items,         :uuid, :uuid, null: false, default: 'uuid_generate_v4()'
    add_column :subscriptions, :uuid, :uuid, null: false, default: 'uuid_generate_v4()'
    add_column :users,         :uuid, :uuid, null: false, default: 'uuid_generate_v4()'
    add_column :videos,        :uuid, :uuid, null: false, default: 'uuid_generate_v4()'

    add_column :items,         :subscription_uuid, :uuid
    add_column :items,         :video_uuid,        :uuid
    add_column :subscriptions, :channel_uuid,      :uuid
    add_column :subscriptions, :user_uuid,         :uuid
    add_column :videos,        :channel_uuid,      :uuid

    execute 'UPDATE items SET subscription_uuid = subscriptions.uuid FROM subscriptions WHERE items.subscription_id = subscriptions.id'
    execute 'UPDATE items SET video_uuid = videos.uuid FROM videos WHERE items.video_id = videos.id'
    execute 'UPDATE subscriptions SET channel_uuid = channels.uuid FROM channels WHERE subscriptions.channel_id = channels.id'
    execute 'UPDATE subscriptions SET user_uuid = users.uuid FROM users WHERE subscriptions.user_id = users.id'
    execute 'UPDATE videos SET channel_uuid = channels.uuid FROM channels WHERE videos.channel_id = channels.id'

    change_column_null :items,         :subscription_uuid, false
    change_column_null :items,         :video_uuid,        false
    change_column_null :subscriptions, :channel_uuid,      false
    change_column_null :subscriptions, :user_uuid,         false
    change_column_null :videos,        :channel_uuid,      false

    remove_column :items,         :subscription_id, :integer
    remove_column :items,         :video_id,        :integer
    remove_column :subscriptions, :channel_id,      :integer
    remove_column :subscriptions, :user_id,         :integer
    remove_column :videos,        :channel_id,      :integer

    rename_column :items,         :subscription_uuid, :subscription_id
    rename_column :items,         :video_uuid,        :video_id
    rename_column :subscriptions, :channel_uuid,      :channel_id
    rename_column :subscriptions, :user_uuid,         :user_id
    rename_column :videos,        :channel_uuid,      :channel_id

    add_index :items,         :subscription_id
    add_index :items,         :video_id
    add_index :subscriptions, :channel_id
    add_index :subscriptions, :user_id
    add_index :videos,        :channel_id

    remove_column :channels,      :id, :integer
    remove_column :items,         :id, :integer
    remove_column :subscriptions, :id, :integer
    remove_column :users,         :id, :integer
    remove_column :videos,        :id, :integer

    rename_column :channels,      :uuid, :id
    rename_column :items,         :uuid, :id
    rename_column :subscriptions, :uuid, :id
    rename_column :users,         :uuid, :id
    rename_column :videos,        :uuid, :id

    execute 'ALTER TABLE channels      ADD PRIMARY KEY (id)'
    execute 'ALTER TABLE items         ADD PRIMARY KEY (id)'
    execute 'ALTER TABLE subscriptions ADD PRIMARY KEY (id)'
    execute 'ALTER TABLE users         ADD PRIMARY KEY (id)'
    execute 'ALTER TABLE videos        ADD PRIMARY KEY (id)'

    add_index :channels,      :id,                     unique: true
    add_index :items,         :id,                     unique: true
    add_index :subscriptions, :id,                     unique: true
    add_index :subscriptions, [:user_id, :channel_id], unique: true
    add_index :users,         :id,                     unique: true
    add_index :videos,        :id,                     unique: true

    add_foreign_key :items,         :subscriptions
    add_foreign_key :items,         :videos
    add_foreign_key :subscriptions, :channels
    add_foreign_key :subscriptions, :users
    add_foreign_key :videos,        :channels
  end
end
