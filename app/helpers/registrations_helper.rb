module RegistrationsHelper
  def define_attribute_values(user_params)
    user = User.new(user_params)
    stripe_customer_id = StripeService::CreateCustomer.new.call
    user.stripe_customer_id = stripe_customer_id
    user
  end
end