class TokujoSaleOrders::SucceededController < ApplicationController
  include CheckoutSessionExistable
  layout "public_for_patrons"
  
  def index
    authorize :tokujo_sale_order, :index?

    tokujo = Tokujo.find(params[:tokujo_id])
    order = Order.find(params[:id])
    checkout_session = @checkout_session

    case tokujo.payment_collection_timing
    when "immediate"
      # Payment was collected, so we need to update the item_status and 
      # status for this order.
      order.item_status = :payment_received
      order.status = :closed
      order.save

      # Close tokujo
      tokujo.status = :closed
      tokujo.save
    when "delayed"
      # A payment method has been successfully attached to the setup intent object 
      # stored in Stripe's database, so we need to update the item_status for 
      # this order.
      order.item_status = :payment_due
      order.save

      # Update the number of Tokujo items taken.
      tokujo.number_of_items_taken += order.size
      tokujo.save 

      # If the Tokujo status == "closed" and number_of_items_taken == number_of_items_available, 
      # then we need to queue a job to charge all of the patrons that placed an order for 
      # this Tokujo.
      if tokujo.status == :closed and tokujo.number_of_items_taken == tokujo.number_of_items_available
        ChargePatronPaymentMethodsJob.perform_later tokujo.orders
      end
    end

    # The checkout session is finished as soon as the patron has reached this page, 
    # so we need to destroy the checkout session instance in our database.
    checkout_session.destroy 
  end
end
