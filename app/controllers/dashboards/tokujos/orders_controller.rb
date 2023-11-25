class Dashboards::Tokujos::OrdersController < ApplicationController
  def index
    authorize :dashboard, :index?

    tokujo = Tokujo.find(params[:id]) 

    # Set instance variables for view
    @orders = tokujo.orders
    @keys = Order.column_names
  end


  
  def show
    authorize :dashboard, :show?

    order = Order.find(params[:order_id])

    # Set instance variables for new
    @order = order
  end
end
