class DestroyCheckoutSessionJob < ApplicationJob
  queue_as :default

  def perform(checkout_session)
    checkout_session.destroy 
  end
end
