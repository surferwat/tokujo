class TokujoSaleOrders::CardSetupsController < ApplicationController
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

    # Find or create setup intent
    setup_intent = nil
    stripe_setup_intent_id = order.stripe_setup_intent_id 
    if stripe_setup_intent_id != nil
      setup_intent = StripeApiCaller::SetupIntent.new.retrieve_setup_intent(stripe_setup_intent_id)
    else
      user = tokujo.user
      on_behalf_of = user.stripe_account_id
      stripe_customer_id = user_patron.stripe_customer_id
      stripe_automatic_payment_methods = {enabled: true, allow_redirects: "never"}    
      setup_intent = StripeApiCaller::SetupIntent.new.create_setup_intent(stripe_customer_id: stripe_customer_id, metadata: {order_id: order_id}, stripe_automatic_payment_methods: stripe_automatic_payment_methods, on_behalf_of: on_behalf_of)
      order.update_columns(stripe_setup_intent_id: setup_intent.id) # use update_columns instead of save because save would run all validations
    end
    
    # Set instance variables for the view
    @stripe_publishable_key = Rails.application.credentials.stripe[:publishable_key]
    @stripe_client_secret = setup_intent.client_secret
    @base_url = Rails.env.production? ? ENV["RAILS_DEFAULT_URL_HOST"] : "localhost:3000"
    @tokujo_id = tokujo.id
    @order_id = order_id
    @checkout_session_id = checkout_session.id
    @intent_type = "setup_intent"
  end
end