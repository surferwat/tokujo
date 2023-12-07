class ChargePatronPaymentMethodsJob < ApplicationJob
  queue_as :default

  def perform(order_ids)
    orders = Order.where(id: order_ids)
    orders.each do |order|
      setup_intent = StripeApiCaller::SetupIntent.new.retrieve_setup_intent(order.stripe_setup_intent_id)
 
      payment_intent = StripeApiCaller::PaymentIntent.new.create_payment_intent(
        amount: order.payment_amount_base, # Use Money gem method, cents, to display value in cents, 
        currency: order.payment_amount_currency,
        stripe_customer_id: setup_intent.customer, 
        payment_method_id: setup_intent.payment_method, 
        off_session: true,
        confirm: true, 
        metadata: { order_id: order.id },
        on_behalf_of: setup_intent.on_behalf_of
      )

      if payment_intent.amount_received == payment_intent.amount
        order.update_columns(item_status: :payment_received) # use update_columns instead of save because save would run all validations
      else 
        # QUESTION: How should we handle case when payment method that is stored cannot be processed?
      end
    end
  end
end