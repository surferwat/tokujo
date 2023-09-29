class CreateCheckoutSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :checkout_sessions do |t|
      t.references :user_patron, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
