class CreateTokujos < ActiveRecord::Migration[7.0]
  def change
    create_table :tokujos do |t|
      t.datetime :ends_at, null: false
      t.datetime :closed_at
      t.integer :status, default: 0, null: false
      t.integer :number_of_items_available, null: false
      t.integer :number_of_items_taken, default: 0
      t.references :menu_item, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
