class AddDefaultCurrencyToMenuItems < ActiveRecord::Migration[7.0]
  def change
    change_column_default :menu_items, :price_currency, "USD"
    change_column_default :menu_items, :price_with_tax_currency, "USD"
  end
end
