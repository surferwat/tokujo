class DashboardsController < ApplicationController
  def index
    authorize :tokujo, :index?
    
    tokujos = Current.user.tokujos.where(status: "open")
    menu_items = Current.user.menu_items

    # Set instance variables for view
    @tokujos = tokujos
    @menu_items = menu_items
  end
end