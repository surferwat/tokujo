class DashboardsController < ApplicationController
  def index
    authorize :dashboard, :index?
    
    tokujos = Current.user.tokujos.order(created_at: :desc).limit(2)
    menu_items = Current.user.menu_items.order(created_at: :desc).limit(2)

    # Set instance variables for view
    @tokujos = tokujos
    @menu_items = menu_items
  end
end