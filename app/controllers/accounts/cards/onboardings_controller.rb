class Accounts::Cards::OnboardingsController < ApplicationController
  def index
    authorize :account, :index?

    #	Get Stripe Account Identifier for user.
    user = Current.user
    stripe_account_id = user.stripe_account_id

    if stripe_account_id.nil?
      stripe_account = StripeApiCaller::Account.new.create_account
      user.stripe_account_id = stripe_account.id 
      user.save
      stripe_account_id = user.stripe_account.id
    end

		# Create Stripe Account Link
    base_url = Rails.env.production? ? ENV["RAILS_DEFAULT_URL_HOST"] : "localhost:3000"
    stripe_account_link = StripeApiCaller::AccountLink.new.create_account_link(
      stripe_account_id: stripe_account_id, 
      refresh_url: "http://#{base_url}/accounts/cards/onboardings/dead_link", 
      return_url: "http://#{base_url}/accounts/cards/onboardings/processed"
    )

		# Redirect user to account link URL
    redirect_to  stripe_account_link.url, allow_other_host: true
  end
end