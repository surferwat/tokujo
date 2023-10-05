class TokujoSalesController < ApplicationController
  layout "public_for_patrons"

  def show
    authorize :tokujo_sale, :show?
  
    tokujo = Tokujo.find(params[:tokujo_id])

    payment_collection_timing = tokujo.payment_collection_timing
    case payment_collection_timing
    when "immediate"
    when "delayed"
      # There is a possibility that a patron never completes a checkout process that 
      # they started. In such a scenario, there is a possibility that the Tokujo status 
      # was changed to "closed". If so, then the status would need to be changed back 
      # to "open". Otherwise, we would have a case where the number_of_items_taken < 
      # number_of_items_available, yet the Tokujo status is "closed".
      
      if tokujo.closed? && tokujo.number_of_items_taken < tokujo.number_of_items_available
        tokujo.status = "open"
        tokujo.save
      end
    end

    # Redirect if closed.
    redirect_to root_path and return if tokujo.closed?
    
    # We need to manage the checkout process, so create a checkout session.
    checkout_session = CheckoutSession.create(user_patron_id: nil, order_id: nil)

    # Make instance variables available in view
    @tokujo = tokujo
    @checkout_session_id = checkout_session.id

    # Render appropriate view
    case payment_collection_timing
    when "immediate"
      render :show_for_immediate
    when "delayed"
      render :show_for_delayed
    end
  end
end