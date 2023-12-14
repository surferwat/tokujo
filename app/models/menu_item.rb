class MenuItem < ApplicationRecord
  TAX_FACTOR = 1.08 # 1 + consumption tax rate
  
  # Concerns
  include Downcaseable
  self.downcase_attribute_name = :price_currency

  # Associations
  belongs_to :user
  has_one_attached :image_one, dependent: :destroy
  has_many :tokujos
  
  # Monetization
  monetize :price_base, with_model_currency: :price_currency
  monetize :price_with_tax_base, with_model_currency: :price_currency

  # Callbacks
  before_save :update_price_with_tax, if: :will_save_change_to_price_base?
  
  # Validations
  validates :sku, uniqueness: true
  validates :name, presence: true
  validates :max_ingredient_storage_life, presence: true, numericality: { greater_than: 0 }
  validates :max_ingredient_delivery_time, presence: true, numericality: { greater_than: 0 }
  validates :price_base, presence: true, numericality: { greater_than: 0 }
  validates :price_currency, presence: true



  private



  def update_price_with_tax
    update_with_tax(:price_base, :price_with_tax_base)
  end



  def update_with_tax(price_field, price_with_tax_field)
    send("#{price_with_tax_field}=", send(price_field) * TAX_FACTOR)
  end
end