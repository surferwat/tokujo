class ChargePatronPaymentMethodsJob < ApplicationJob
  queue_as :default

  def perform(orders)
    orders.each do |order|

      setup_intent = StripeApiCaller::SetupIntent.new.retrieve_setup_intent(order.stripe_setup_intent_id)
      
      payment_intent = StripeApiCaller::PaymentIntent.new.create_payment_intent(
        amount: order.payment_amount.cents, # Use Money gem method, cents, to display value in cents, 
        stripe_customer_id: setup_intent.customer, 
        payment_method_id: setup_intent.payment_method, 
        off_session: true,
        confirm: true, 
        metadata: { order_id: order.id }
      )

      if payment_intent.amount_received == payment_intent.amount
        order.item_status = :payment_received
        order.save
      else 
        # QUESTION: How should we handle case when payment method that is stored cannot be processed?
      end
    end
  end
end
