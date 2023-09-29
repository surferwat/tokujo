require "test_helper"

class TokujoTest < ActiveSupport::TestCase
  def setup
    @tokujo = tokujos(:tokujo_one)
  end

  # Validations
  test "should be valid" do 
    assert @tokujo.valid?
  end

  test "ends_at should be present" do 
    @tokujo.ends_at = nil
    assert_not @tokujo.valid?
  end

  test "status should be present" do 
    @tokujo.status = nil
    assert_not @tokujo.valid?
  end

  test "number_of_items_available should be present and greater than 0" do
    @tokujo.number_of_items_available = nil
    assert_not @tokujo.valid?

    @tokujo.number_of_items_available = 0
    assert_not @tokujo.valid?

    @tokujo.number_of_items_available = -1
    assert_not @tokujo.valid?

    @tokujo.number_of_items_available = 9.99
    assert @tokujo.valid?
  end

  # Associations
  test "should belong to user" do
    assert_respond_to @tokujo, :user
  end

  test "should belong to menu_item" do
    assert_respond_to @tokujo, :menu_item
  end

  test "should have many orders" do 
    assert_respond_to @tokujo, :orders
  end
end
