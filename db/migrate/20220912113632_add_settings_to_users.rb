class AddSettingsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :settings, :jsonb, null: false, default: {}
  end
end
