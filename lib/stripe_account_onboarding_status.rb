class StripeAccountOnboardingStatus
  VALUES = {
    not_onboarded: 0,
    onboarded: 1,
    onboarded_but_incomplete: 2
  }.freeze

  def self.values
    VALUES
  end
end