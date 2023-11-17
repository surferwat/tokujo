class Tokujo < ApplicationRecord
  # Associations
  belongs_to :menu_item
  belongs_to :user
  has_many :orders

  # Enumerations
  enum status: { open: 0, closed: 1 }
  enum payment_collection_timing: { immediate: 0, delayed: 1 }

  # Validations
  validates :status, presence: true
  validates :headline, presence: true, uniqueness: true
  validates :menu_item_id, presence: true
  validates :user_id, presence: true
  validates :payment_collection_timing, presence: true
  validate :payment_collection_timing_delayed_attributes

  # Callbacks
  before_save :set_default_value_for_number_of_items_taken, if: :payment_collection_timing_is_delayed?

  def set_default_value_for_number_of_items_taken
    self.number_of_items_taken ||= 0
  end

  private

  def payment_collection_timing_delayed_attributes
    case payment_collection_timing 
    when "immediate"
      validate_ingredients_procurement_time_absence
      validate_ingredients_expiration_time_absence
      validate_order_period_starts_at_absence
      validate_order_period_ends_at_absence
      validate_eat_period_starts_at_absence
      validate_eat_period_ends_at_absence
      validate_number_of_items_available_absence
      validate_number_of_items_taken_absence
    when "delayed"
      validate_ingredients_procurement_time_presence
      validate_ingredients_procurement_time_numericality
      validate_ingredients_expiration_time_presence
      validate_ingredients_expiration_time_numericality
      validate_order_period_starts_at_presence
      validate_order_period_starts_at_not_in_past
      validate_order_period_ends_at_presence
      validate_order_period_ends_at_greater_than_order_period_starts_at
      validate_eat_period_starts_at_presence
      validate_eat_period_starts_at_after_ingredients_procurement
      validate_eat_period_ends_at_presence
      validate_eat_period_ends_at_after_eat_period_starts_at
      validate_eat_period_ends_at_before_ingredients_expire
      validate_number_of_items_available_presence
      validate_number_of_items_available_numericality
    end
  end



  # Validations for when payment collection timing is set to "immediate"
  def validate_ingredients_procurement_time_absence
    errors.add(:ingredients_procurement_time, "must be blank when value for payment_collection_timing is not :delayed") if !ingredients_procurement_time.nil?
  end



  def validate_ingredients_expiration_time_absence
    errors.add(:ingredients_expiration_time, "must be blank when value for payment_collection_timing is not :delayed") if !ingredients_expiration_time.nil?
  end



  def validate_order_period_starts_at_absence
    errors.add(:order_period_starts_at, "must be blank when value for payment_collection_timing is not :delayed") if !order_period_starts_at.nil?
  end



  def validate_order_period_ends_at_absence
    errors.add(:order_period_ends_at, "must be blank when value for payment_collection_timing is not :delayed") if !order_period_ends_at.nil?
  end



  def validate_eat_period_starts_at_absence
    errors.add(:eat_period_starts_at, "must be blank when value for payment_collection_timing is not :delayed") if !eat_period_starts_at.nil?
  end



  def validate_eat_period_ends_at_absence
    errors.add(:eat_period_ends_at, "must be blank when value for payment_collection_timing is not :delayed") if !eat_period_ends_at.nil?
  end



  def validate_number_of_items_available_absence
    errors.add(:number_of_items_available, "must be blank when value for payment_collection_timing is not :delayed") if !number_of_items_available.nil? 
  end



  def validate_number_of_items_taken_absence
    errors.add(:number_of_items_taken, "must be blank when value for payment_collection_timing is not :delayed") if !number_of_items_taken.nil?
  end



  # Validations for when payment collection timing is set to "delayed"
  def validate_ingredients_procurement_time_presence
    errors.add(:ingredients_procurement_time, "cant be blank when value for payment_collection_timing is :delayed") if ingredients_procurement_time.nil?
  end



  def validate_ingredients_procurement_time_numericality
    errors.add(:ingredients_procurement_time, "must be greater than or equal to 0") if !ingredients_procurement_time.present? or ingredients_procurement_time < 0
  end



  def validate_ingredients_expiration_time_presence
    errors.add(:ingredients_expiration_time, "cant be blank when value for payment_collection_timing is :delayed") if ingredients_expiration_time.nil?
  end



  def validate_ingredients_expiration_time_numericality
    errors.add(:ingredients_expiration_time, "must be greater than or equal to 0") if !ingredients_expiration_time.present? or ingredients_expiration_time < 0
  end



  def validate_order_period_starts_at_presence
    errors.add(:order_period_starts_at, "cant be blank when value for payment_collection_timing is :delayed") if order_period_starts_at.nil?
  end


 
  def validate_order_period_starts_at_not_in_past
    if order_period_starts_at.present? && (order_period_starts_at < DateTime.current.beginning_of_day)
      errors.add(:order_period_starts_at, "must be the current datetime or later")
    end
  end


  def validate_order_period_ends_at_presence
    errors.add(:order_period_ends_at, "cant be blank when value for payment_collection_timing is :delayed") if order_period_ends_at.nil?
  end



  def validate_order_period_ends_at_greater_than_order_period_starts_at
    if order_period_ends_at.present? && order_period_starts_at.present? && order_period_ends_at <= order_period_starts_at
      errors.add(:order_period_ends_at, "must be greater than order_period_starts_at")
    end
  end



  def validate_eat_period_starts_at_presence
    errors.add(:eat_period_starts_at, "cant be blank when value for payment_collection_timing is :delayed") if eat_period_starts_at.nil?
  end



  def validate_eat_period_starts_at_after_ingredients_procurement
    if eat_period_starts_at.present? && order_period_ends_at.present? && (eat_period_starts_at <= (order_period_ends_at + ingredients_procurement_time.days))
      errors.add(:eat_period_starts_at, "must be later than order_period_ends_at plus ingredients_procurement_time")
    end
  end



  def validate_eat_period_ends_at_presence
    errors.add(:eat_period_ends_at, "cant be blank when value for payment_collection_timing is :delayed") if eat_period_ends_at.nil?
  end

  

  def validate_eat_period_ends_at_after_eat_period_starts_at
    return if !eat_period_ends_at.present? || !eat_period_starts_at.present? 

    if eat_period_ends_at <= eat_period_starts_at
      errors.add(:eat_period_ends_at, "must be after the eat_period_starts_at")
    end
  end



  def validate_eat_period_ends_at_before_ingredients_expire
    return if !eat_period_ends_at.present? || !eat_period_starts_at.present? 
    
    if eat_period_ends_at > (eat_period_starts_at + ingredients_expiration_time.days)
      errors.add(:eat_period_ends_at, "must be before the eat_period_starts_at + ingredients_expiration_time")
    end
  end



  def validate_number_of_items_available_presence
    errors.add(:number_of_items_available, "cant be blank when value for payment_collection_timing is :delayed") if number_of_items_available.nil? 
  end



  def validate_number_of_items_available_numericality
    errors.add(:number_of_items_available, "must be greater than 0") if !number_of_items_available.present? or number_of_items_available <= 0
  end


  
  def payment_collection_timing_is_delayed?
    payment_collection_timing == "delayed"
  end
end