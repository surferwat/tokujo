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
  validates :menu_item_id, presence: true
  validates :user_id, presence: true
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
      validate_ends_at_absence
      validate_number_of_items_available_absence
      validate_number_of_items_taken_absence
    when "delayed"
      validate_ends_at_presence
      validate_number_of_items_available_presence
      validate_number_of_items_available_numericality
    end
  end



  def validate_ends_at_absence
    errors.add(:ends_at, "must be blank when value for payment_collection_timing is not :delayed") if !ends_at.nil?
  end



  def validate_number_of_items_available_absence
    errors.add(:number_of_items_available, "must be blank when value for payment_collection_timing is not :delayed") if !number_of_items_available.nil? 
  end



  def validate_number_of_items_taken_absence
    errors.add(:number_of_items_taken, "must be blank when value for payment_collection_timing is not :delayed") if !number_of_items_taken.nil?
  end



  def validate_ends_at_presence
    errors.add(:ends_at, "cant be blank when value for payment_collection_timing is :delayed") if ends_at.nil?
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