class TokujoSales::Patrons::Orders::CardSetupsController < ApplicationController
  layout "public_for_patrons"

  def index
    authorize :tokujo_sale, :index?

    tokujo_id = params[:tokujo_id]
 
    # Check whether checkout session exists
    checkout_session = CheckoutSession.find_by(id: params[:checkout_session_id])
    if checkout_session == nil
      redirect_to tokujo_sale_path(tokujo_id)
      return
    end

    # Set variables
    order_id = params[:id]
    order = Order.find(order_id)
    tokujo = Tokujo.find(tokujo_id)
    user_patron = UserPatron.find(params[:patron_id])
    user = tokujo.user

    # Find or create setup intent
    setup_intent = nil
    stripe_setup_intent_id = order.stripe_setup_intent_id 
    if stripe_setup_intent_id != nil
      setup_intent = StripeApiCaller::SetupIntent.new.retrieve_setup_intent(stripe_setup_intent_id)
    else
      on_behalf_of = user.stripe_account_id
      stripe_customer_id = user_patron.stripe_customer_id
      stripe_automatic_payment_methods = {enabled: true, allow_redirects: "never"}
      setup_intent = StripeApiCaller::SetupIntent.new.create_setup_intent(stripe_customer_id: stripe_customer_id, metadata: {order_id: order_id}, stripe_automatic_payment_methods: stripe_automatic_payment_methods, on_behalf_of: on_behalf_of)
      order.stripe_setup_intent_id = setup_intent.id
    end
    
    # Set instance variables for the view
    @stripe_publishable_key = Rails.application.credentials.stripe[:publishable_key]
    @setup_intent_client_secret = setup_intent.client_secret
    @base_url = Rails.env.production? ? ENV["RAILS_DEFAULT_URL_HOST"] : "localhost:3000"
    @tokujo_id = tokujo.id
    @user_patron_id = user_patron.id
    @order_id = order_id
    @checkout_session_id = checkout_session.id
  end
end
