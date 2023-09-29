require 'test_helper'

class SettingPolicyTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_one)
  end

  def test_index
    policy = SettingPolicy.new(@user, nil)
    assert policy.index?
  end

  def test_edit
    policy = SettingPolicy.new(@user, nil)
    assert policy.edit?
  end

  def test_update
    policy = SettingPolicy.new(@user, nil)
    assert policy.update?
  end
end
