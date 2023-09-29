class ChangeNullConstraintInCheckoutSessions < ActiveRecord::Migration[7.0]
  def change
    change_column :checkout_sessions, :user_patron_id, :bigint, null: true
    change_column :checkout_sessions, :order_id, :bigint, null: true
  end
end
