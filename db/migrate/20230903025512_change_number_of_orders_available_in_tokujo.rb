class ChangeNumberOfOrdersAvailableInTokujo < ActiveRecord::Migration[7.0]
  def change
    rename_column :tokujos, :number_of_orders_available, :number_of_items_available
    rename_column :tokujos, :number_of_items_taken, :number_of_items_taken
  end
end
