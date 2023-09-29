class MenuItem < ApplicationRecord
  TAX_FACTOR = 1.08 # 1 + consumption tax rate

  # Associations
  belongs_to :user
  has_one_attached :image_one, dependent: :destroy
  has_many :tokujos
  
  # Monetization
  monetize :price_cents, with_model_currency: :currency
  monetize :price_with_tax_cents, with_model_currency: :currency

  # Callbacks
  before_save :update_price_with_tax, if: :will_save_change_to_price_cents?
  
  # Validations
  validates :sku, uniqueness: true
  validates :name, presence: true
  validates :max_ingredient_storage_life, presence: true, numericality: { greater_than: 0 }
  validates :max_ingredient_delivery_time, presence: true, numericality: { greater_than: 0 }
  validates :price_cents, presence: true, numericality: { greater_than: 0 }
  validates :currency, presence: true

  # Methods
  def price_with_tax
    price_with_tax_cents / 100.0
  end

  def price_with_tax=(value)
    self.price_with_tax_cents = value * 100
  end

  private

  def update_price_with_tax
    update_with_tax(:price_cents, :price_with_tax_cents)
  end

  def update_with_tax(price_field, price_with_tax_field)
    send("#{price_with_tax_field}=", send(price_field) * TAX_FACTOR)
  end
end
