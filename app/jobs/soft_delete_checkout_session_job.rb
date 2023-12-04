class SoftDeleteCheckoutSessionJob < ApplicationJob
  queue_as :default

  def perform(checkout_session)
    checkout_session.update_column(:deleted_at, Time.now)
  end
end
