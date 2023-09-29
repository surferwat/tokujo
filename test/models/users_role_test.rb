require "test_helper"

class UsersRoleTest < ActiveSupport::TestCase
  # Associations
  test "should belong to user" do
    users_role = UsersRole.new
    assert_respond_to users_role, :user
  end

  test "should belong to role" do
    users_role = UsersRole.new
    assert_respond_to users_role, :role
  end
end
