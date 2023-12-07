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
    @price_with_tax = Money.new(tokujo.menu_item.price_with_tax_base, tokujo.menu_item.price_currency)
    @total_price_with_tax = Money.new(total_price_with_tax, tokujo.menu_item.price_currency)
    @button_label = tokujo.payment_collection_timing == "immediate" ? "Proceed to payment" : "Proceed to card setup"
  end



  def create
    authorize :tokujo_sale_order, :create?

    tokujo_id = params[:order][:tokujo_id]
    user_patron_id = params[:patron_id]
    size = params[:order][:size]
    size_i = size.to_i
    total_price_with_tax = params[:order][:payment_amount]
    checkout_session = @checkout_session # Instantiated in CheckoutSessionExistable

    tokujo = Tokujo.find(tokujo_id)
    user_patron = UserPatron.find(user_patron_id)

    tokujo_payment_collection_timing = tokujo.payment_collection_timing
    case tokujo_payment_collection_timing
    when "immediate"
      if checkout_session.order_id != nil
        order = Order.find(checkout_session.order_id)
      else
        order = user_patron.orders.new(order_params)
        if order.save  
          # Update checkout session
          update_checkout_session(checkout_session, order.id)
        else
          # Set instance variables for views
          set_instance_variables(checkout_session.id, user_patron_id, order, Tokujo.find(tokujo_id), total_price_with_tax, UserPatron.new, "Proceed to card payment")
  
          # Render new
          render :new, status: :unprocessable_entity
          return
        end
      end
      
      redirect_to tokujo_sale_orders_card_payments_path(tokujo_id: order.tokujo_id, patron_id: order.user_patron_id, id: checkout_session.order_id, checkout_session_id: checkout_session.id)
    when "delayed"
      if checkout_session.order_id != nil
        order = Order.find(checkout_session.order_id)
      else
        order = user_patron.orders.new(order_params)
        if order.save
          if tokujo_payment_collection_timing == "delayed"
  
            curr_aggr_placed_size = tokujo.number_of_items_taken + size_i
  
            # Update number of items taken for this tokujo
            tokujo.number_of_items_taken = curr_aggr_placed_size
  
            # If the number of orders placed by the patron results in the
            # number_of_items_taken == number_of_items_available, then
            # we need to close this tokujo instance.
  
            if curr_aggr_placed_size == tokujo.number_of_items_available
              tokujo.status = "closed"
            end
  
            tokujo.save
          end
  
          # Update checkout session
          update_checkout_session(checkout_session, order.id)
        else
          # Set instance variables for views
          set_instance_variables(checkout_session.id, user_patron_id, order, Tokujo.find(tokujo_id), total_price_with_tax, UserPatron.new, "Proceed to card setup")
  
          # Render new
          render :new, status: :unprocessable_entity
          return
        end
      end

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



  def check_max_aggr_size(size, curr_aggr_placed_size, max_aggr_size)
    new_aggr_size = new_curr_aggr_placed_size(size, curr_aggr_placed_size)
    new_aggr_size == max_aggr_size
  end



  def set_instance_variables(
    checkout_session_id, 
    user_patron_id, 
    order, 
    tokujo, 
    size, 
    total_price_with_tax, 
    user_patron, 
    button_label
  )
    @checkout_session_id = checkout_session_id
    @patron_id = user_patron_id
    @order = order
    @tokujo = tokujo
    @size = size
    @total_price_with_tax = total_price_with_tax
    @user_patron = user_patron
    @button_label = button_label
  end



  def update_checkout_session(checkout_session, order_id)
    checkout_session.order_id = order_id
    checkout_session.save 
  end
end