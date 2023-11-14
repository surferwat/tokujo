class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    StripeWebhookHandler.new.evaluate_event(request)
    render status: 200, json: {} # Acknowledge receipt of the event
  end
end
