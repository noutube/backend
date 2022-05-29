class AddDeletedToItemsState < ActiveRecord::Migration[6.1]
  def up
    add_enum_value :item_state, :deleted
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
