class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :username
      t.string :password_digest, null: false
      t.string :stripe_customer_id, null: false
      t.string :password_reset_token
      t.datetime :password_reset_token_sent_at

      t.index :password_reset_token, name: "index_users_on_password_reset_token"

      t.timestamps
    end
  end
end
