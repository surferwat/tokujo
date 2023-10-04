class TokujoSaleOrdersController < ApplicationController
  layout "public_for_patrons"

  def new
    authorize :tokujo_sale, :new?

    tokujo_id = params[:tokujo_id]
    patron_id = params[:patron_id]

    # Check whether checkout session exists
    checkout_session = CheckoutSession.find_by(id: params[:checkout_session_id])
    if checkout_session == nil
      redirect_to tokujo_sale_path(tokujo_id)
      return
    end

    # Set instance variables for views
    @checkout_session_id = checkout_session.id
    @order = Order.new
    @tokujo = Tokujo.find(tokujo_id)
    @patron_id = patron_id
    @size = params[:size]
    @total_price_with_tax = params[:total_price_with_tax]
  end

  def create
    authorize :tokujo_sale, :create?

    tokujo_id = params[:tokujo_id]

    # Check whether checkout session exists
    checkout_session = CheckoutSession.find_by(id: params[:checkout_session_id])
    if checkout_session == nil
      redirect_to tokujo_sale_path(tokujo_id)
      return
    end

    # Handle where patron comes to this page from another page ahead in the 
    # checkout session process and decides to press the set up card button again.
    # We don't want to create a new order for this session. Just use the
    # existing order.
    if checkout_session.order_id != nil
      order = Order.find(checkout_session.order_id)
      redirect_to tokujo_sale_orders_card_setups_path(tokujo_id: order.tokujo_id, patron_id: order.user_patron_id, id: order.id, checkout_session_id: checkout_session.id)
      return
    end

    # Create new order
    user_patron = UserPatron.find(params[:patron_id])
    order = user_patron.orders.new(order_params)
    if order.save
      redirect_to tokujo_sale_orders_card_setups_path(tokujo_id: order.tokujo_id, patron_id: order.user_patron_id, id: order.id, checkout_session_id: checkout_session.id)
    else
      # Set instance variables for views
      @checkout_session_id = checkout_session.id
      @order = Order.new
      @tokujo = Tokujo.find(tokujo_id)
      @size = params[:size]
      @total_price_with_tax = params[:total_price_with_tax]
      @user_patron = UserPatron.new

      # Render new
      render :new, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(
      :size, 
      :payment_amount, 
      :tokujo_id
    )
  end 
end
