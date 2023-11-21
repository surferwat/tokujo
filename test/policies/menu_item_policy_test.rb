require 'test_helper'

class MenuItemPolicyTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_one)
  end

  def test_scope
    user_menu_item = menu_items(:menu_item_one)
    policy_scope = MenuItemPolicy::Scope.new(@user, MenuItem).resolve
    assert_includes policy_scope, user_menu_item
  end

  def test_index
    policy = MenuItemPolicy.new(@user, nil)
    assert policy.index?
  end
end
