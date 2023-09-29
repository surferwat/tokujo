class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :size, null: false
      t.decimal :payment_amount, null: false, precision: 8, scale: 2
      t.integer :status, default: 0, null: false
      t.integer :item_status, default: 0, null: false
      t.references :user, foreign_key: true
      t.references :tokujo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
