class AddHeadlineToTokujos < ActiveRecord::Migration[7.0]
  def change
    add_column :tokujos, :headline, :string
  end
end
