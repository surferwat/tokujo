require 'json'
require 'stripe'
require "./lib/stripe_account_onboarding_status.rb"

class StripeWebhookHandler
  def evaluate_event
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
      when "account.updated" 
        # Not used
      else
        puts "Unhandled event type: #{event.type}"
    end
  end
end