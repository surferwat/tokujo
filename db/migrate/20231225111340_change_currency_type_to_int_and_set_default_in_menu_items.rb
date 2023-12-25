class ChangeCurrencyTypeToIntAndSetDefaultInMenuItems < ActiveRecord::Migration[7.0]
  def up
    # Add a new integer column
    add_column :menu_items, :currency_int, :integer, default: 0

    # Set the new column's value based on the existing string column
    execute <<-SQL
      UPDATE menu_items
      SET currency_int = CASE currency
                         WHEN 'USD' THEN 0
                         WHEN 'JPY' THEN 1
                         ELSE 0  -- Set a default value for other cases
                       END;
    SQL

    # Remove the old string column
    remove_column :menu_items, :currency

     # Rename the new integer column to the original name
     rename_column :menu_items, :currency_int, :currency
  end

  def down
    # Add the string column back
    add_column :menu_items, :currency, :string, default: 'USD'

    # Set the string column's value based on the existing integer column
    execute <<-SQL
      UPDATE menu_items
      SET currency = CASE currency_int
                     WHEN 0 THEN 'USD'
                     WHEN 1 THEN 'JPY'
                     ELSE 'USD'  -- Set a default value for other cases
                   END;
    SQL

    # Remove the integer column
    remove_column :menu_items, :currency_int
  end
end
