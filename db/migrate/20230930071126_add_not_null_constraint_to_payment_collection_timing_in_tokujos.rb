class AddNotNullConstraintToPaymentCollectionTimingInTokujos < ActiveRecord::Migration[7.0]
  def change
    change_column_null :tokujos, :payment_collection_timing, false
  end
end
