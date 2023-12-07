class AddPaymentAmountCurrencyToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :payment_amount_currency, :string
  end
end
