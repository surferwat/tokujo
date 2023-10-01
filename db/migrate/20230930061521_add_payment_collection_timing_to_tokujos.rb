class AddPaymentCollectionTimingToTokujos < ActiveRecord::Migration[7.0]
  def change
    add_column :tokujos, :payment_collection_timing, :integer
  end
end
