class AddUserPatronIdToOrder < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :user_patron, null: false, foreign_key: true
  end
end
