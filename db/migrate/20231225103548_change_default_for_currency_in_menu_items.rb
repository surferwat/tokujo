class ChangeDefaultForCurrencyInMenuItems < ActiveRecord::Migration[7.0]
  def change
    change_column_default :menu_items, :currency, "USD"
  end
end