class TokujoSales::Orders::CardSetupsController < ApplicationController
  def index
    authorize :tokujo_sale, :index?

    order = Order.find(params[:id])
    stripe_customer_id = order.user_patron.stripe_customer_id
    base_url = Rails.env.production? ? ENV["RAILS_DEFAULT_URL_HOST"] : "localhost:3000"

    # Set your secret key. Remember to switch to your live secret key in production.
    # See your keys here: https://dashboard.stripe.com/apikeys
    Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
    session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      mode: "setup",
      customer: stripe_customer_id,
      success_url: "http://#{base_url}/tokujo_sales/#{params[:tokujo_id]}/orders/#{:id}/succeeded?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: "http://#{base_url}/tokujo_sales/#{params[:tokujo_id]}/orders/#{:id}/failed",
    )

    redirect_to session.url
  end
end