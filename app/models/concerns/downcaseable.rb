module Downcaseable
  extend ActiveSupport::Concern

  included do
    before_validation :downcase_attribute
    class_attribute :downcase_attribute_name
  end

  def downcase_attribute
    if send(self.class.downcase_attribute_name).present?
      attribute_name = self.class.downcase_attribute_name
      self.send("#{attribute_name}=", send(attribute_name).downcase)
    end
  end
end