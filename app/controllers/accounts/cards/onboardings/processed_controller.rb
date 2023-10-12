class Accounts::Cards::Onboardings::ProcessedController < ApplicationController
  def index
    authorize :account, :index?

    # Set status of Stripe Connect account onboarding for this user.
    status, stripe_account = StripeConnectAccountStatusSetter.new.set_account_status 

    case status
    when 1
      message = "Thank you for onboarding your account."
    when 2
      message = "Thank you for onboarding your account, but you are still missing capabilities or required verification information."
    end

    # Set instance variables for views
    @status = status
    @message = message
  end
end
