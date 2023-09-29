# In the current setup the patron is asked to provide information for 
# the credit card that should be charged to complete the order. There 
# should only be one setup intent per order, so we need to check whether 
# a setup intent already exists.

class StripeSetupIntentCreation
  def find_or_create_setup_intent(order)
    stripe_customer_id = order.user_patron.stripe_customer_id

    # Retrieve list of setup intents for this customer.
    setup_intent_list = StripeApiCaller::SetupIntent.new.list_all_setup_intents(stripe_customer_id)
    filtered_setup_intent_list = setup_intent_list.select { |intent| intent.metadata.order_id.to_i == order.id }

    # Find incomplete setup intent or create setup intent variable
    setup_intent = nil
    setup_already_completed = false
    automatic_payment_methods = { enabled: true }
    if filtered_setup_intent_list.empty?
      setup_intent = StripeApiCaller::SetupIntent.new.create_setup_intent(stripe_customer_id, { order_id: order.id }, nil, automatic_payment_methods)
    else
      succeeded_setup_intent_list = filtered_setup_intent_list.select { |intent| intent.status == "succeeded" }
      if !succeeded_setup_intent_list.empty?
        setup_already_completed = true
      else
        filtered_setup_intent_list.each do |intent|
          if intent.status != "canceled"
            StripeApiCaller::SetupIntent.new.cancel_setup_intent(intent.id)
          end
        end
        setup_intent = StripeApiCaller::SetupIntent.new.create_setup_intent(stripe_customer_id, { order_id: order.id }, nil, automatic_payment_methods)
      end
    end

    # Return setup_intent
    [ setup_already_completed, setup_intent ]
  end
end