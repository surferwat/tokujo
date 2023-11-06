class AddAttributesToTokujos < ActiveRecord::Migration[7.0]
  def change
    add_column :tokujos, :ingredients_procurement_time, :integer
    add_column :tokujos, :ingredients_expiration_time, :integer
    add_column :tokujos, :order_period_starts_at, :datetime
    add_column :tokujos, :eat_period_starts_at, :datetime
    add_column :tokujos, :eat_period_ends_at, :datetime
  end
end
