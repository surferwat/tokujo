class ChangeNullConstraintInTokujos < ActiveRecord::Migration[7.0]
  def change
    change_column :tokujos, :number_of_items_available, :integer, null: true
  end
end
