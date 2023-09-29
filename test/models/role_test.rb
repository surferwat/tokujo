require "test_helper"

class RoleTest < ActiveSupport::TestCase
  # Validations
  test "valid role" do
    role = Role.new(name: "admin")
    assert role.valid?
  end

  test "should be valid without resource_type" do
    role = Role.new(name: "guest")
    assert role.valid?
  end

  test "should be invalid with an invalid resource_type" do
    role = Role.new(name: "guest")
    role.resource_type = "InvalidResourceType"
    refute role.valid?
    assert_not_nil role.errors[:resource_type]
  end

  # Associations
  test "has_and_belongs_to_many association with users" do
    role = Role.new(name: "user")
    assert_respond_to role, :users
    assert_empty role.users
  end

  test "belongs_to association with resource" do
    role = Role.new(name: "user")
    assert_respond_to role, :resource
  end
end
