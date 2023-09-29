require "./lib/stripe_account_onboarding_status.rb"

class StripeConnectAccountStatusSetter
  def set_account_status
    stripe_account_id = Current.user.stripe_account_id
    stripe_account = get_stripe_connect_account(stripe_account_id)
    if stripe_account_id.nil?
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
        # TODO: Handle case where stripe account id attached to user is invalid.
      end
    end
    stripe_account
  end
end