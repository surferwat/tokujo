module EmailFormatValidation
  extend ActiveSupport::Concern

  included do
    validates :email, format: {
      with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i,
      message: "must be a valid email address"
    }
  end
end