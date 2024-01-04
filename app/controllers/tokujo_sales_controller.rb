class TokujoSalesController < ApplicationController
  layout "public_for_patrons"
  
  def show
    authorize :tokujo_sale, :show?
  
    tokujo = Tokujo.find(params[:tokujo_id])

    payment_collection_timing = tokujo.payment_collection_timing
    case payment_collection_timing
    when "immediate"
    when "delayed"
      # There is a possibility that a patron never completes card setup. The Tokujo 
      # status is changed to "closed" prior to the card setup step in order effectively 
      # lock the Tokujo from other patrons placing orders. Since the patron failed to set up 
      # their card, the order process would not have been completed so the Tokujo status would 
      # need to be changed back to "open". Otherwise, we would have a case where the actual 
      # number_of_items_taken < number_of_items_available, yet the Tokujo status is "closed".

      # Determine number of completed orders (i.e., those that have completed card setup as 
      # that is the last step in the process).
      number_of_completed_orders = tokujo.orders.where(status: "open", item_status: "payment_due").sum(:size)

      # Handle dirty orders for which card setup was not completed.
      if tokujo.closed? && (number_of_completed_orders < tokujo.number_of_items_available)
        number_of_dirty_orders = 0
        estimated_minutes_to_input_card_info = 2 * 60 # 2 minutes in seconds

        # Destroy order and corresponding checkout session.
        orders = tokujo.orders.each do |order|
      
          # For whatever reason, a patron may be just slow at filling out their card details, so we give 
          # the patron some time (in seconds) to complete card setup during which we do not count their order
          # in progress as a dirty order.
          time_difference_in_minutes = (Time.current - order.created_at) 
          
          if (order.item_status == "payment_method_required") && (time_difference_in_minutes > estimated_minutes_to_input_card_info)
            number_of_dirty_orders = number_of_dirty_orders + order.size
            CheckoutSession.find_by(order_id: order.id, user_patron_id: order.user_patron_id).destroy
            order.destroy
          end
        end

        # Reopen tokujo
        if (tokujo.number_of_items_taken - number_of_dirty_orders) < tokujo.number_of_items_available
          tokujo.status = "open"
          tokujo.number_of_items_taken = tokujo.number_of_items_taken - number_of_dirty_orders
          tokujo.save
        end
      end
    end

    # Redirect if closed.
    redirect_to root_path and return if tokujo.closed?
    
    # We need to manage the checkout process, so create a checkout session.
    checkout_session = CheckoutSession.create(user_patron_id: nil, order_id: nil)

    # Make instance variables available in view
    @tokujo_id = tokujo.id
    @checkout_session_id = checkout_session.id
    @tokujo_headline = tokujo.headline
    @tokujo_description = tokujo.menu_item.description
    @is_image_attached = tokujo.menu_item.image_one.attached?
    @tokujo_image_url = @is_image_attached ? rails_blob_path(tokujo.menu_item.image_one, only_path: true) : nil
    @price_with_tax = Money.new(tokujo.menu_item.price_with_tax_base, tokujo.menu_item.currency).format

    # Render appropriate view
    case payment_collection_timing
    when "immediate"
      render :show_for_immediate
    when "delayed"
      # Make instance variables available in view
      @number_of_items_remaining = tokujo.number_of_items_available - tokujo.number_of_items_taken
      @number_of_items_available = tokujo.number_of_items_available
      @order_period_starts_at = tokujo.order_period_starts_at.strftime("%m/%d/%Y")
      @order_period_ends_at = tokujo.order_period_ends_at.strftime("%m/%d/%Y")
      @eat_period_starts_at = tokujo.eat_period_starts_at.strftime("%m/%d/%Y")
      @eat_period_ends_at = tokujo.eat_period_ends_at.strftime("%m/%d/%Y")

      render :show_for_delayed
    else
      raise ArgumentError
    end
  end
end