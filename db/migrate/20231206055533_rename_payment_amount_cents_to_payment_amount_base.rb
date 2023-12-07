class RenamePaymentAmountCentsToPaymentAmountBase < ActiveRecord::Migration[7.0]
  def change
    rename_column :orders, :payment_amount_cents, :payment_amount_base
  end
end
