class CreateMenuItems < ActiveRecord::Migration[7.0]
  def change
    create_table :menu_items do |t|
      t.string :sku
      t.string :name, null: false
      t.integer :max_ingredient_storage_life, null: false
      t.integer :max_ingredient_delivery_time, null: false
      t.integer :price_cents, default: 0, null: false
      t.integer :price_currency, default: "USD", null: false
      t.integer :price_with_tax_cents, default: 0, null: false
      t.integer :price_with_tax_currency, default: "USD", null: false
      
      t.timestamps
    end
  end
end