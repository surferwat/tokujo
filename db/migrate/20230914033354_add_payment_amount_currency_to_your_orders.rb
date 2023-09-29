class AddPaymentAmountCurrencyToYourOrders < ActiveRecord::Migration[7.0]
  def change
    def change
      add_column :orders, :payment_amount_currency, :string, default: "USD", null: false
    end
  end
end
