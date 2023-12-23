class RemoveCurrencyColumnsFromMenuItems < ActiveRecord::Migration[7.0]
  def change
    remove_column :menu_items, :price_currency, :string
    remove_column :menu_items, :price_with_tax_currency, :string
  end
end
