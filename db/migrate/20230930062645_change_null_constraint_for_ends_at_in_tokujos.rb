class ChangeNullConstraintForEndsAtInTokujos < ActiveRecord::Migration[7.0]
  def change
    change_column :tokujos, :ends_at, :datetime, null: true
  end
end
