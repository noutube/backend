class AddProgressToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :progress, :integer, null: false, default: 0
  end
end
