require 'test_helper'

class RegistrationPolicyTest < ActiveSupport::TestCase
  def test_new
    policy = RegistrationPolicy.new(nil, nil)
    assert_not policy.new?
  end

  def test_create
    policy = RegistrationPolicy.new(nil, nil)
    assert_not policy.create?
  end
end