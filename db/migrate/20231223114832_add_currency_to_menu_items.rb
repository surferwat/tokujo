class AddCurrencyToMenuItems < ActiveRecord::Migration[7.0]
  def change
    add_column :menu_items, :currency, :string
  end
end
