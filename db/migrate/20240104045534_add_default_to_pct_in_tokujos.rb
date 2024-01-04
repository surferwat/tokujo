class AddDefaultToPctInTokujos < ActiveRecord::Migration[7.0]
  def up
    # Add a new integer column with the desired default value
    add_column :tokujos, :new_payment_collection_timing, :integer, default: 1

    # Update existing records with the default value
    Tokujo.update_all(new_payment_collection_timing: 1)

    # Remove the old enum column
    remove_column :tokujos, :payment_collection_timing

    # Rename the new column to match the original name
    rename_column :tokujos, :new_payment_collection_timing, :payment_collection_timing
  end

  def down
    # Add a new enum column with the original default value
    add_column :tokujos, :new_payment_collection_timing, :integer, default: 0

    # Update existing records with the original default value
    Tokujo.update_all(new_payment_collection_timing: 0)

    # Remove the old integer column
    remove_column :tokujos, :payment_collection_timing

    # Rename the new column to match the original name
    rename_column :tokujos, :new_payment_collection_timing, :payment_collection_timing
  end
end
