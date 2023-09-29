class User < ApplicationRecord
  # Constants
  TOKEN_LENGTH = 36
  MIN_PASSWORD_LENGTH = 6
  MAX_PASSWORD_LENGTH = 20
  MAX_USERNAME_LENGTH = 15

  # In-built Methods
  has_secure_token :password_reset_token, length: TOKEN_LENGTH
  has_secure_password
  
  # Associations
  has_many :menu_items
  has_many :tokujos
  has_many :orders
  
  # Validations
  include EmailFormatValidation
  validates :email, presence: true, uniqueness: true
  validates :stripe_customer_id, presence: true, uniqueness: true
  validates :password, allow_blank: true, length: { in: MIN_PASSWORD_LENGTH..MAX_PASSWORD_LENGTH }
  validates :username, uniqueness: true, allow_blank: true, length: { maximum: MAX_USERNAME_LENGTH, too_long: "%{count} characters is the maximum allowed" }, format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only allows letters, numbers, and underscores" }

  # Third-party Methods
  rolify

  # Custom Methods
  def valid_reset_token?
    password_reset_token_sent_at&.to_i >= (Time.now - 10.minutes).to_i
  end

  def reset_password
    regenerate_password_reset_token
    update(password_reset_token_sent_at: Time.current)
  end
end
