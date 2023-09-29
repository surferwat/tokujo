class TokujoSalesController < ApplicationController
  layout "public_for_patrons"
  
  def show
    authorize :tokujo_sale, :show?
  
    tokujo = Tokujo.find(params[:tokujo_id])

    # Redirect if closed. There is a possibility that a patron never completes a 
    # checkout process that they started. In such a scenario, if the Tokujo 
    # status was changed to "closed", then the status needs to be changed back to 
    # "open". Otherwise, we would have a case where the number_of_items_taken < 
    # number_of_items_available, yet the Tokujo status is "closed".
    if tokujo.closed?
      if tokujo.number_of_items_taken < tokujo.number_of_items_available
        tokujo.status = "open"
        tokujo.save
      else
        redirect_to root_path
        return
      end
    end

    # We need to manage the checkout process, so create a checkout session.
    checkout_session = CheckoutSession.create(user_patron_id: nil, order_id: nil)

    # Make instance variables available in view
    @tokujo = tokujo
    @checkout_session_id = checkout_session.id
  end
end