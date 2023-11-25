class Dashboards::TokujosController < ApplicationController
  def index
    authorize :dashboard, :index?

    tokujo = Current.user.tokujos.find(params[:id]) # where returns [] if no match
    menu_item = MenuItem.find(tokujo.menu_item_id)

    # Set instance variables for view
    @tokujo_sales_url = url_for(action: "show", controller: "/tokujo_sales", tokujo_id: tokujo.id, only_path: false)
    @tokujo = tokujo
  end
end
