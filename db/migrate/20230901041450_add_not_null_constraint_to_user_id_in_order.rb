class AddNotNullConstraintToUserIdInOrder < ActiveRecord::Migration[7.0]
  def change
    change_column :orders, :user_id, :bigint, null: false
  end
end
