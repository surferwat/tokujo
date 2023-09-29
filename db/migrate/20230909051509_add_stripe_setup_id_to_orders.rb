class AddStripeSetupIdToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :stripe_setup_intent_id, :string
  end
end
