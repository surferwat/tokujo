class UserPatron < ApplicationRecord
  # Associations
  has_many :orders

  # Validations
  include EmailFormatValidation
  validates :email, presence: true, uniqueness: true
  validates :stripe_customer_id, presence: true, uniqueness: true
end
