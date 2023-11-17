require 'json'
require 'sinatra'
require 'stripe'
require "./lib/stripe_account_onboarding_status.rb"

class StripeWebhookHandler
  def evaluate_event(request)
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
    endpoint_secret = Rails.application.credentials.dig(:stripe, :endpoint_secret)

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      # Invalid payload
      status 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      status 400
      return
    end

    # Handle the event
    case event.type
      when "payment_intent.succeeded" 
        payment_intent = event.data.object
        handle_payment_intent(payment_intent)
      when "setup_intent.succeeded"
        setup_intent = event.data.object
        handle_setup_intent(setup_intent)
      else
        puts "Unhandled event type: #{event.type}"
    end
  end



  private



  def destroy_checkout_session(checkout_session)
    if !checkout_session.nil?
      DestroyCheckoutSessionJob.set(wait: 1.minute).perform_later(checkout_session)
    end
  end



  def send_succeeded_email(order, user_patron, tokujo, user)
    TokujoSaleOrders::SucceededMailer.with(order: order, user_patron: user_patron, tokujo: tokujo, user: user).succeeded_email.deliver_later
  end



  def handle_payment_intent(payment_intent)
    order_id = payment_intent.metadata.order_id
    
    order = Order.find(order_id)
    user_patron = UserPatron.find(order.user_patron_id)
    tokujo = Tokujo.find(order.tokujo_id)
    user = User.find(tokujo.user_id)
    checkout_session = CheckoutSession.find_by(order_id: order.id, user_patron_id: user_patron.id)
    
    # There are two situations where a "payment_intent.succeeded" event occurs. The first
    # is when we are able to successfully process a card payment for tokujos with 
    # payment_collection_timing set to immediate. The second for tokujos with 
    # payment_collection_timing set to delayed. In the second situation, we process card
    # payments for multiple orders in batch, so handle changing the status for the tokujo
    # in a different way. Thus, we only want to execute the following code for the first
    # situation (i.e., where payment_collection_timing is set to immediate).
    if tokujo.payment_collection_timing == "immediate"
      # Payment was collected, so we need to update the item_status and 
      # status for this order.
      order.item_status = :payment_received
      order.status = :closed
      order.save

      # Tell the SucceededMailer to send a order succeeded email to patron.
      send_succeeded_email(order, user_patron, tokujo, user)

      # Close tokujo
      tokujo.status = :closed
      tokujo.save

      # The checkout session is finished as soon as the patron has reached this page, 
      # so we need to destroy the checkout session instance in our database. We want
      # to provide some time for the server to render the relevant view for the client, 
      # so add a time delay.
      destroy_checkout_session(checkout_session)
    end
  end



  def handle_setup_intent(setup_intent)
    order_id = setup_intent.metadata.order_id
 
    order = Order.find(order_id)
    user_patron = UserPatron.find(order.user_patron_id)
    tokujo = Tokujo.find(order.tokujo_id)
    user = User.find(tokujo.user_id)
    checkout_session = CheckoutSession.find_by(order_id: order.id, user_patron_id: user_patron.id)


    # A payment method has been successfully attached to the setup intent object 
    # stored in Stripe's database, so we need to update the item_status for 
    # this order.
    order.update_columns(item_status: "payment_due")

    # Tell the SucceededMailer to send a order succeeded email to patron.
    send_succeeded_email(order, user_patron, tokujo, user)

    # If the Tokujo status == "closed" and number_of_items_taken == number_of_items_available, 
    # then we need to queue a job to charge all of the patrons that placed an order for 
    # this Tokujo.
    if tokujo.status == :closed and tokujo.number_of_items_taken == tokujo.number_of_items_available
      ChargePatronPaymentMethodsJob.perform_later tokujo.orders
    end

    # The checkout session is finished as soon as the patron has reached this page, 
    # so we need to destroy the checkout session instance in our database. We want
    # to provide some time for the server to render the relevant view for the client, 
    # so add a time delay.
    destroy_checkout_session(checkout_session)
  end
end