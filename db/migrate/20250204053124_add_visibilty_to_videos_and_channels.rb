class AddVisibiltyToVideosAndChannels < ActiveRecord::Migration[6.1]
  def change
    create_enum :visibility, [:visible, :banned, :removed, :private, :age]
    add_column :channels, :visibility, :visibility, default: :visible, null: false
    add_column :videos, :visibility, :visibility, default: :visible, null: false
  end
end
