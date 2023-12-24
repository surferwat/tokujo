class ChangePaymentAmountCurrencyDataTypeInOrders < ActiveRecord::Migration[7.0]
  def up
    # Add a new column for temporary storage
    add_column :orders, :new_payment_amount_currency, :integer

    # Update the new column with integer values based on the existing string values
    execute <<-SQL
    UPDATE orders
    SET new_payment_amount_currency =
      CASE payment_amount_currency
        WHEN 'jpy' THEN 1
        WHEN 'usd' THEN 0
        ELSE NULL
      END
    SQL

    # Drop the old column
    remove_column :orders, :payment_amount_currency

    # Rename the new column to the original column name
    rename_column :orders, :new_payment_amount_currency, :payment_amount_currency
  end

  def down
    # Revert the changes if needed
    add_column :orders, :new_payment_amount_currency, :string

    # Update the new column with string values based on the existing integer values
    execute <<-SQL
      UPDATE orders
      SET new_payment_amount_currency =
        CASE
          WHEN payment_amount_currency = 1 THEN 'jpy'
          WHEN payment_amount_currency = 0 THEN 'usd'
          ELSE NULL
        END
    SQL

    remove_column :orders, :payment_amount_currency
    rename_column :orders, :new_payment_amount_currency, :payment_amount_currency
  end
end
