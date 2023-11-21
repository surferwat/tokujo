require 'test_helper'

class DashboardPolicyTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_one)
  end

  def test_index
    policy = DashboardPolicy.new(@user, nil)
    assert policy.index?
  end
end
