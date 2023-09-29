class CheckoutSession < ApplicationRecord
  belongs_to :user_patron, optional: true
  belongs_to :order, optional: true
end
