class TokujoSaleOrders::CardPaymentsController < ApplicationController
  include CheckoutSessionExistable
  layout "public_for_patrons"

  def index
    authorize :tokujo_sale_order, :index?

    tokujo_id = params[:tokujo_id]
    order_id = params[:id]
    user_patron_id = params[:patron_id]
    checkout_session = @checkout_session

    tokujo = Tokujo.find(tokujo_id)
    order = Order.find(order_id)
    user_patron = UserPatron.find(user_patron_id)   

    # Find or create payment intent
    payment_intent = nil
    stripe_payment_intent_id = order.stripe_payment_intent_id 
    if stripe_payment_intent_id != nil
      payment_intent = StripeApiCaller::PaymentIntent.new.retrieve_payment_intent(stripe_payment_intent_id)
    else
      user = tokujo.user
      on_behalf_of = user.stripe_account_id
      stripe_customer_id = user_patron.stripe_customer_id
      payment_intent = StripeApiCaller::PaymentIntent.new.create_payment_intent(amount: order.payment_amount.cents, stripe_customer_id: stripe_customer_id, metadata: {order_id: order_id}, on_behalf_of: on_behalf_of)
      order.stripe_payment_intent_id = payment_intent.id
      order.save
    end
    
    # Set instance variables for the view
    @stripe_publishable_key = Rails.application.credentials.stripe[:publishable_key]
    @stripe_client_secret = payment_intent.client_secret
    @base_url = Rails.env.production? ? ENV["RAILS_DEFAULT_URL_HOST"] : "localhost:3000"
    @tokujo_id = tokujo.id
    @order_id = order_id
    @checkout_session_id = checkout_session.id
    @intent_type = "payment_intent"
  end
end