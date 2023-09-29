class CreateCancellations < ActiveRecord::Migration[7.0]
  def change
    create_table :cancellations do |t|
      t.bigint :user_id, null: false
      t.string :user_email, null: false
      t.string :user_username, null: false
      t.datetime :user_created_at, null: false
      t.datetime :user_updated_at, null: false
      t.string :user_stripe_customer_id, null: false

      t.timestamps
    end
  end
end
