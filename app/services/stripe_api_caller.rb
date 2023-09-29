require 'stripe'

module StripeApiCaller
  class PaymentIntent
    def create_payment_intent(payment_method_types: ["card"], amount: , currency: "usd", customer_id: , payment_method_id: , off_session: , confirm: , metadata: )
      Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
    
      payment_intent = Stripe::PaymentIntent.create({
        payment_method_types: payment_method_types,
        amount: amount,
        currency: currency,
        customer: customer_id,
        payment_method: payment_method_id,
        off_session: off_session,
        confirm: confirm,
        metadata: metadata,
      })
    end
  end



  class SetupIntent
    def initialize
      Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
    end

    def create_setup_intent(stripe_customer_id: , metadata: , stripe_payment_method_id: nil, stripe_automatic_payment_methods: , on_behalf_of: )
      setup_intent = Stripe::SetupIntent.create({
        customer: stripe_customer_id,
        metadata: metadata,
        payment_method: stripe_payment_method_id,
        automatic_payment_methods: stripe_automatic_payment_methods,
        on_behalf_of: on_behalf_of, # The Stripe account ID for the user for which these funds are intended.
      })
    end

    def confirm_setup_intent(stripe_setup_intent_id, stripe_payment_method_id)
      Stripe::SetupIntent.confirm(stripe_setup_intent_id, {payment_method: stripe_payment_method_id})
    end

    def retrieve_setup_intent(stripe_setup_intent_id)
      setup_intent = Stripe::SetupIntent.retrieve(stripe_setup_intent_id)
    end

    def list_all_setup_intents(stripe_customer_id)
      setup_intent_list = Stripe::SetupIntent.list({
        customer: stripe_customer_id
      }).data
    end

    def cancel_setup_intent(setup_intent_id)
      Stripe::SetupIntent.cancel(setup_intent_id)
    end
  end



  class Customer
    def initialize
      Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
    end

    def create_customer
      customer = Stripe::Customer.create
    end

    def retrieve_customer(stripe_customer_id)
      customer = Stripe::Customer.retrieve(stripe_customer_id)
    end
  end

  

  class PaymentMethod
    def create_payment_method(type, card)
      Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
      payment_method = Stripe::PaymentMethod.create({
        type: type,
        card: card
      })
    end
  end



  class Account
    def initialize
      Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
    end

    def create_account
      account = Stripe::Account.create({type: "standard"})
    end

    def retrieve_account(stripe_account_id)
      begin
        account = Stripe::Account.retrieve(stripe_account_id)
      rescue Stripe::StripeError => e
        e
      end
      [account, e]
    end
  end



  class AccountLink
    def create_account_link(stripe_account_id:, refresh_url:, return_url:, type: "account_onboarding")
      Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
      
      account_link = Stripe::AccountLink.create({
        account: stripe_account_id,
        refresh_url: refresh_url,
        return_url: return_url,
        type: type,
      })
    end
  end
end