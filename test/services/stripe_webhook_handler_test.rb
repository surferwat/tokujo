require 'minitest/autorun'
require 'rack'
require "json"
require "stripe"
require "test_helper"

class StripeWebhookHandlerTest < ActionDispatch::IntegrationTest
  setup do
    @order_for_delayed_tokujo = orders(:order_one)
    @order_for_immediate_tokujo = orders(:order_two)
    @user_patron = user_patrons(:user_patron_one)
    @user = users(:user_one)
  end



  test "should return 200 successful for payment_intent.succeeded event" do
    VCR.use_cassette("payment_intent_succeeded") do
      payment_intent = StripeApiCaller::PaymentIntent.new.create_payment_intent(amount: @order_for_immediate_tokujo.payment_amount_base, stripe_customer_id: @user_patron.stripe_customer_id, metadata: {order_id: @order_for_immediate_tokujo.id}, on_behalf_of: @user.stripe_account_id)
    end
    VCR.eject_cassette
    
    request_body = StripeHelpers.construct_webhook_request("payment_intent_succeeded","payment_intent.succeeded")
    webhook_signing_secret = Rails.application.credentials.dig(:stripe, :endpoint_secret)
    stripe_signature = generate_stripe_signature(Time.at(JSON.parse(request_body)["created"]), request_body, webhook_signing_secret)

    post webhooks_path, params: request_body, headers: { "HTTP_STRIPE_SIGNATURE" => stripe_signature, "Content-Type" => "application/json" }
    assert_response :success
  end



  test "should return 200 successful for setup_intent.succeeded event" do
    VCR.use_cassette("setup_intent_succeeded") do
      setup_intent = StripeApiCaller::SetupIntent.new.create_setup_intent(stripe_customer_id: @user_patron.stripe_customer_id, metadata: {order_id: @order_for_delayed_tokujo.id}, stripe_automatic_payment_methods: { enabled: true, allow_redirects: "never" }  , on_behalf_of: @user.stripe_account_id)
    end
    VCR.eject_cassette
    
    request_body = StripeHelpers.construct_webhook_request("setup_intent_succeeded","setup_intent.succeeded")
    webhook_signing_secret =  Rails.application.credentials.dig(:stripe, :endpoint_secret)
    stripe_signature = generate_stripe_signature(Time.at(JSON.parse(request_body)["created"]), request_body, webhook_signing_secret)

    post webhooks_path, params: request_body, headers: { "HTTP_STRIPE_SIGNATURE" => stripe_signature, "Content-Type" => "application/json" }
    assert_response :success
  end



  private



  def generate_stripe_signature(timestamp, payload, signing_secret)
    signature = Stripe::Webhook::Signature.compute_signature(timestamp, payload, signing_secret)
    Stripe::Webhook::Signature.generate_header(timestamp,signature)
  end
end