class Tokujo < ApplicationRecord
  # Associations
  belongs_to :menu_item
  belongs_to :user
  has_many :orders

  # Enumerations
  enum status: { open: 0, closed: 1 }

  # Validations
  validates :ends_at, presence: true
  validates :number_of_items_available, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  validates :menu_item_id, presence: true
  validates :user_id, presence: true
end