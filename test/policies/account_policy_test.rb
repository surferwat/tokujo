require 'test_helper'

class AccountPolicyTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_one)
  end

  def test_index
    policy = AccountPolicy.new(@user, nil)
    assert policy.index?
  end

  def test_new
    policy = AccountPolicy.new(@user, nil)
    assert policy.new?
  end

  def test_create
    policy = AccountPolicy.new(@user, nil)
    assert policy.create?
  end
end
