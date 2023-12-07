class RenamePriceWithTaxCentsToPriceWithTaxBase < ActiveRecord::Migration[7.0]
  def change
    rename_column :menu_items, :price_with_tax_cents, :price_with_tax_base
  end
end
