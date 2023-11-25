class Dashboards::Tokujos::MenuItemsController < ApplicationController
  def index
    authorize :dashboard, :index?

    tokujo = Tokujo.find(params[:id])

    # Set instance variables for view
    @menu_item = tokujo.menu_item
  end
end
