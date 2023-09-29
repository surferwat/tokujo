class Cancellation < ApplicationRecord
  # Validations
  validates :user_id, presence: true
  validates :user_email, presence: true
  validates :user_created_at, presence: true
  validates :user_updated_at, presence: true
  validates :user_stripe_customer_id, presence: true
end
