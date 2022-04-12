class AddUniqueIndexToItems < ActiveRecord::Migration[6.1]
  def change
    add_index :items, [:user_id, :video_id], unique: true
  end
end
