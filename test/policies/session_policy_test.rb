require 'test_helper'

class SessionPolicyTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_one)
  end

  def test_new
    policy = SessionPolicy.new(nil, nil)
    assert policy.new?
  end

  def test_create
    policy = SessionPolicy.new(nil, nil)
    assert policy.create?
  end

  def test_destroy
    policy = SessionPolicy.new(@user, nil)
    assert policy.destroy?
  end
end
