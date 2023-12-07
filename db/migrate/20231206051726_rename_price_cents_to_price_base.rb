class RenamePriceCentsToPriceBase < ActiveRecord::Migration[7.0]
  def change
    rename_column :menu_items, :price_cents, :price_base
  end
end
