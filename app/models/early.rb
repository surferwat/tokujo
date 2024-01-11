class Early < ApplicationRecord
  include EmailFormatValidation
  validates :email, presence: true, uniqueness: true
end
