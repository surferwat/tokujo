class RemoveDefaultFromNumberOfItemsTaken < ActiveRecord::Migration[7.0]
  def change
    change_column_default :tokujos, :number_of_items_taken, from: "Default Value", to: nil
  end
end
