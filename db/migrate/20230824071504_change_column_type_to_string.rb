class ChangeColumnTypeToString < ActiveRecord::Migration[7.0]
  def up
    change_column :menu_items, :price_currency, :string
    change_column :menu_items, :price_with_tax_currency, :string
  end

  def down
    change_column :menu_items, :price_currency, :integer
    change_column :menu_items, :price_with_tax_currency, :integer
  end
end
