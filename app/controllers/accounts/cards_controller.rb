class Accounts::CardsController < ApplicationController
  def index
    authorize :account, :index?

    # Set status of Stripe Connect account onboarding for this user.
    status, stripe_account = StripeConnectAccountStatusSetter.new.set_account_status 

    # Set variables dependent on user's status of Stripe Connect onboarding.
    case status
    when 0
      message = t("controllers.accounts.cards_controller.index.you_have_not_onboarded_your_bank_account_") 
      stripe_account_detail = nil
      button_label = t("controllers.accounts.cards_controller.index.go_onboard")
    when 1
      message = t("controllers.accounts.cards_controller.index.you_have_onboarded_your_bank_account_") 
      stripe_account_detail = { charges_enabled: stripe_account.charges_enabled, payouts_enabled: stripe_account.payouts_enabled }
    when 2
      message = t("controllers.accounts.cards_controller.index.you_have_started_the_onboarded_process,_but_are_still_missing_capabilities_or_required_verification_information_") 
      stripe_account_detail = { charges_enabled: stripe_account.charges_enabled, payouts_enabled: stripe_account.payouts_enabled }
      button_label = t("controllers.accounts.cards_controller.index.go_fill_out_missing_information") 
    else
      # TODO: How to handle? Status should always be 0,1, or 2. If this block executes, then unexpected behavior.
    end
    
    # Set instance variables for view
    @status = status
    @message = message
    @stripe_account_detail = stripe_account_detail
    @button_label = button_label

    @stripe_account = stripe_account
  end
end
