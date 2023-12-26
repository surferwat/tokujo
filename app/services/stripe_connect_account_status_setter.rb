require "./lib/stripe_account_onboarding_status.rb"

class StripeConnectAccountStatusSetter
  def set_account_status
    stripe_account_id = Current.user.stripe_account_id
    stripe_account = get_stripe_connect_account(stripe_account_id)

    # Handle edge case where the user deletes their account directly through Stripe's website.
    if stripe_account_id.present? && stripe_account.nil?
      user = Current.user
      user.stripe_account_id = nil
      user.save
    end

    if stripe_account.nil?
      status = StripeAccountOnboardingStatus::VALUES[:not_onboarded]
    else
      if stripe_account.charges_enabled && stripe_account.payouts_enabled
        status = StripeAccountOnboardingStatus::VALUES[:onboarded]
      else
        status = StripeAccountOnboardingStatus::VALUES[:onboarded_but_incomplete]
      end
    end

    [status, stripe_account]
  end


  
  private



  def get_stripe_connect_account(stripe_account_id)
    if !stripe_account_id.nil?
      stripe_account, e = StripeApiCaller::Account.new.retrieve_account(stripe_account_id)
      if !e.nil?
        # account ID does not exist
        # TODO: Rails.logger.error, Account ID does not exist. For this stripe_account_id, 
        # there was no corresponding account at Stripe. Next step is to investigate the 
        # reason why (most likely user deleted their account through Stripe's dashboard) 
        # and stripe_account_id should be set to nil. 
      end
    end
    stripe_account
  end
end