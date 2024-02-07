class Dashboards::Tokujos::OrdersController < ApplicationController
  def index
    authorize :dashboard, :index?

    tokujo = Tokujo.find(params[:id]) 

    # Set instance variables for view
    @orders = tokujo.orders
    @view_name = "dashboards.tokujos.orders"
    @columns_to_display = ["id","status","item_status","size","payment_amount_currency","payment_amount_base", "created_at","user_patron_id"]
  end


  
  def show
    authorize :dashboard, :show?

    order = Order.find(params[:order_id])

    # Set instance variables for new
    @order = order
  end
end
