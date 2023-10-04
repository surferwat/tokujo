class TokujoSaleOrders::SucceededController < ApplicationController
  layout "public_for_patrons"
  
  def index
    authorize :tokujo_sale, :index?

    # Check whether checkout session exists
    checkout_session = CheckoutSession.find_by(id: params[:checkout_session_id])
    if checkout_session == nil
      redirect_to tokujo_sale_path(params[:tokujo_id])
      return
    end

    tokujo = Tokujo.find(params[:tokujo_id])
    order = Order.find(params[:id])

    # A payment method has been successfully attached to the setup intent object 
    # stored in Stripe's database, so we need to update the item_status for 
    # this order.
    order.item_status = :payment_due
    order.save

    # Update the number of Tokujo items taken.
    tokujo.number_of_items_taken += order.size
    tokujo.save 

    # The checkout session is finished as soon as the patron has reached this page, 
    # so we need to destroy the checkout session instance in our database.
    checkout_session.destroy

    # If the Tokujo status == "closed" and number_of_items_taken == number_of_items_available, 
    # then we need to queue a job to charge all of the patrons that placed an order for 
    # this Tokujo.
    if tokujo.status == :closed and tokujo.number_of_items_taken == tokujo.number_of_items_available
      ChargePatronPaymentMethodsJob.perform_later tokujo.orders
    end
  end
end
