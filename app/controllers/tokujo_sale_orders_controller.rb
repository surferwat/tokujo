class TokujoSaleOrdersController < ApplicationController
  include CheckoutSessionExistable
  layout "public_for_patrons"



  def new
    authorize :tokujo_sale_order, :new?

    tokujo_id = params[:tokujo_id]
    patron_id = params[:patron_id]
    size = params[:size]
    total_price_with_tax = params[:total_price_with_tax]
    checkout_session = @checkout_session # Instantiated in CheckoutSessionExistable

    tokujo = Tokujo.find(tokujo_id)

    # Set instance variables for views
    @checkout_session_id = checkout_session.id
    @order = Order.new
    @tokujo = tokujo
    @patron_id = patron_id
    @size = size
    @total_price_with_tax = total_price_with_tax
    @button_label = tokujo.payment_collection_timing == "immediate" ? "Proceed to payment" : "Proceed to card setup"
  end



  def create
    authorize :tokujo_sale_order, :create?

    tokujo_id = params[:order][:tokujo_id]
    user_patron_id = params[:patron_id]
    size = params[:order][:size]
    total_price_with_tax = params[:order][:total_price_with_tax]
    checkout_session = @checkout_session # Instantiated in CheckoutSessionExistable

    tokujo = Tokujo.find(tokujo_id)
    user_patron = UserPatron.find(user_patron_id)

    if checkout_session.order_id != nil
      order = Order.find(checkout_session.order_id)
    else
      order = user_patron.orders.new(order_params)
      if order.save
        checkout_session.order_id = order.id
        checkout_session.save
      else
        # Set instance variables for views
        @checkout_session_id = checkout_session.id
        @order = Order.new
        @tokujo = Tokujo.find(tokujo_id)
        @size = size
        @total_price_with_tax = total_price_with_tax
        @user_patron = UserPatron.new

        # Render new
        render :new, status: :unprocessable_entity
        return
      end
    end

    case tokujo.payment_collection_timing
    when "immediate"
      redirect_to tokujo_sale_orders_card_payments_path(tokujo_id: order.tokujo_id, patron_id: order.user_patron_id, id: checkout_session.order_id, checkout_session_id: checkout_session.id)
    when "delayed"
      redirect_to tokujo_sale_orders_card_setups_path(tokujo_id: order.tokujo_id, patron_id: order.user_patron_id, id: checkout_session.order_id, checkout_session_id: checkout_session.id)
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