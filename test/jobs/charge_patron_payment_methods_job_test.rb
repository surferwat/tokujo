require "test_helper"

class ChargePatronPaymentMethodsJobTest < ActiveJob::TestCase
  setup do
    @order = set_order
  end

  test "should assert job is performed" do
    assert_performed_jobs 0
    perform_enqueued_jobs do
      ChargePatronPaymentMethodsJob.perform_later([@order])
    end
    assert_performed_jobs 1
  end

  private

  def create_and_confirm_setup_intent(stripe_customer_id, order_id)
    stripe_payment_method_test_token = "pm_card_visa"
    stripe_automatic_payment_methods = { enabled: true, allow_redirects: "never" }
    on_behalf_of = "acct_1Nt5M6RRnhYA07l9"
    
    # Create setup intent
    stripe_setup_intent = StripeApiCaller::SetupIntent.new.create_setup_intent(
      stripe_customer_id: stripe_customer_id, 
      metadata: {order_id: order_id}, 
      stripe_payment_method_id: stripe_payment_method_test_token, 
      stripe_automatic_payment_methods: stripe_automatic_payment_methods, on_behalf_of: on_behalf_of
    )
    
    # Confirm setup intent so that payment method is attached to customer. This is a critical step, otherwise 
    StripeApiCaller::SetupIntent.new.confirm_setup_intent(stripe_setup_intent.id, stripe_setup_intent.payment_method) 
      
    stripe_setup_intent
  end

  def set_order
    stripe_customer_id = StripeApiCaller::Customer.new.create_customer.id
    user_patron_id = UserPatron.create(email: "email@test.com", stripe_customer_id: stripe_customer_id).id
    tokujo_id = tokujos(:tokujo_one).id
    order = Order.create(user_patron_id: user_patron_id, size: 8, payment_amount_base: 10000, payment_amount_currency: "USD", tokujo_id: tokujo_id)
    order.stripe_setup_intent_id = create_and_confirm_setup_intent(stripe_customer_id, order.id).id
    order.save
    order
  end
end
