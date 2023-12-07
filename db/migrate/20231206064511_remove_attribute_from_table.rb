class RemoveAttributeFromTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :menu_items, :currency, :string
  end
end
