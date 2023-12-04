class AddDeletedAtToCheckoutSession < ActiveRecord::Migration[7.0]
  def change
    add_column :checkout_sessions, :deleted_at, :datetime
  end
end
