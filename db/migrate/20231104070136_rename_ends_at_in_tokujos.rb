class RenameEndsAtInTokujos < ActiveRecord::Migration[7.0]
  def change
    rename_column :tokujos, :ends_at, :order_period_ends_at
  end
end
