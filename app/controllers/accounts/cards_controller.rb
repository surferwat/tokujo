class Accounts::CardsController < ApplicationController
  def index
    authorize :account, :index?

    # Set status of Stripe Connect account onboarding for this user.
    status, stripe_account = StripeConnectAccountStatusSetter.new.set_account_status 

    # Set variables dependent on user's status of Stripe Connect onboarding.
    case status
    when 0
      message = "You have not onboarded your bank account."
      stripe_account_detail = nil
      button_label = "Go onboard"
    when 1
      message = "You have onboarded your bank account."
      stripe_account_detail = { charges_enabled: stripe_account.charges_enabled, payouts_enabled: stripe_account.payouts_enabled }
    when 2
      message = "You have onboarded your bank account, but are still missing capabilities or required verification information."
      stripe_account_detail = { charges_enabled: stripe_account.charges_enabled, payouts_enabled: stripe_account.payouts_enabled }
      button_label = "Go fill out missing information"
    else
      # TODO: How to handle? Status should always be 0,1, or 2. If this block executes, then unexpected behavior.
    end
    
    # Set instance variables for view
    @status = status
    @message = message
    @stripe_account_detail = stripe_account_detail
    @button_label = button_label
  end
end
