class MenuItemsController < ApplicationController
  def index
    authorize :menu_item, :index?

    # Set instance variables for view
    @keys = MenuItem.column_names
    @menu_items = MenuItem.where(user_id: Current.user.id)
  end
end
