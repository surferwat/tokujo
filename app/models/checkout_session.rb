class CheckoutSession < ApplicationRecord
  belongs_to :user_patron, optional: true
  belongs_to :order, optional: true

  validates_uniqueness_of :user_patron_id, scope: :order_id, conditions: -> { where.not(order_id: nil, user_patron_id: nil) }
end
