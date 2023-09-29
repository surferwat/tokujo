class Webhooks::StripeController < ApplicationController
  def index
    StripeWebhookHandler.new.evaluate_event()
  end
end
