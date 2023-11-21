require 'test_helper'

class TokujoPolicyTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_one)
  end

  def test_scope
    user_tokujo = tokujos(:tokujo_one)
    policy_scope = TokujoPolicy::Scope.new(@user, Tokujo).resolve
    assert_includes policy_scope, user_tokujo
  end

  def test_index
    policy = TokujoPolicy.new(@user, nil)
    assert policy.index?
  end
end
