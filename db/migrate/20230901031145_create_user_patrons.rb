class CreateUserPatrons < ActiveRecord::Migration[7.0]
  def change
    create_table :user_patrons do |t|
      t.string :email, null: false
      t.string :stripe_customer_id, null: false

      t.timestamps
    end
  end
end
