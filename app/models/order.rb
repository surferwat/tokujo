class Order < ApplicationRecord
  # Associations
  belongs_to :user_patron
  belongs_to :tokujo

  # Monetization
  monetize :payment_amount_cents, with_model_currency: :currency

  # Enum
  # Status of the order
  # reference: https://schema.org/OrderStatus
  #   open = the associated tokujo has not ended or has not been closed
  #   canceled = order has been canceled prior to the closing of the tokujo
  #   expired = order has been canceled because the payment method wasnt provided prior to the closing of the tokujo OR the tokujo ended without fulfilling the orders needed
  #   closed = the associated tokujo and payment has closed and have been made, respectively
  enum status: { open: 0, canceled: 1, expired: 2, closed: 3 }

  # Status of the ordered item
  enum item_status: { payment_method_required: 0, payment_due: 1, payment_received: 2 }

  # Validations
  validates :size, presence: true, numericality: { greater_than: 0 }
  validates :payment_amount, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  validates :item_status, presence: true
  validates :tokujo_id, presence: true
  validate :tokujo_must_be_open
  validate :not_all_items_taken



  private 


  
  def tokujo_must_be_open
    if tokujo && tokujo.closed?
      errors.add(:tokujo_id, "is closed")
    end
  end



  def not_all_items_taken
    if tokujo && (tokujo.payment_collection_timing == "delayed") && ((size.to_i + tokujo.number_of_items_taken) > tokujo.number_of_items_available)
      errors.add(:size, "is too much")
    end
  end
end