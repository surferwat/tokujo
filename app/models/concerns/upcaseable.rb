module Upcaseable
  extend ActiveSupport::Concern

  included do
    before_validation :upcase_attribute
    class_attribute :upcase_attribute_name
  end

  def upcase_attribute
    if send(self.class.upcase_attribute_name).present?
      attribute_name = self.class.upcase_attribute_name
      self.send("#{attribute_name}=", send(attribute_name).upcase)
    end
  end
end