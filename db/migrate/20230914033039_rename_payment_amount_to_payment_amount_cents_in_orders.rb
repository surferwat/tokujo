class RenamePaymentAmountToPaymentAmountCentsInOrders < ActiveRecord::Migration[7.0]
  def change
    rename_column :orders, :payment_amount, :payment_amount_cents
  end
end
