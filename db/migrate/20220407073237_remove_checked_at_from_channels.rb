class RemoveCheckedAtFromChannels < ActiveRecord::Migration[6.1]
  def change
    remove_column :channels, :checked_at, :datetime, null: false
  end
end
