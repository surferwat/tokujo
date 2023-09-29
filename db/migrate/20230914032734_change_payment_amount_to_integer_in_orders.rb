class ChangePaymentAmountToIntegerInOrders < ActiveRecord::Migration[7.0]
  def up
    change_column :orders, :payment_amount, :integer, default: 0, null: false
  end

  def down
    change_column :orders, :payment_amount, :decimal, precision: 8, scale: 2, null: false
  end
end
