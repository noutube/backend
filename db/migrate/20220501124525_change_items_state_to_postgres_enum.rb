class ChangeItemsStateToPostgresEnum < ActiveRecord::Migration[6.1]
  def up
    create_enum :item_state, [:new, :later]
    change_column_default :items, :state, nil
    execute <<-QUERY.squish
      ALTER TABLE items
        ALTER COLUMN state SET DATA TYPE item_state
        USING CASE state
          WHEN 0 THEN 'new'
          WHEN 1 THEN 'later'
        END :: item_state
    QUERY
    change_column_default :items, :state, :new
  end

  def down
    change_column_default :items, :state, nil
    execute <<-QUERY.squish
      ALTER TABLE items
        ALTER COLUMN state SET DATA TYPE integer
        USING CASE state
          WHEN 'new' THEN 0
          WHEN 'later' THEN 1
        END
    QUERY
    change_column_default :items, :state, 0
    drop_enum :item_state
  end
end
