require "test_helper"

class TokujoTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_one)
    @menu_item = menu_items(:menu_item_one)
    @tokujo = tokujos(:tokujo_one)
  end

  # Validations
  test "should be valid" do 
    assert @tokujo.valid?
  end

  test "status should be present" do 
    @tokujo.status = nil
    assert_not @tokujo.valid?
  end

  test "payment_collection_timing should be present" do 
    @tokujo.payment_collection_timing = nil
    assert_not @tokujo.valid?
  end

  test "should not save a record with invalid attributes related to payment collection timing value of delayed" do
    tokujo_with_immediate = Tokujo.new
    tokujo_with_immediate.user_id = @user.id
    tokujo_with_immediate.headline = "headline for immediate"
    tokujo_with_immediate.menu_item_id = @menu_item.id
    # Immediate payment collection timing, so the values for attributes
    # related to this value for payment collection timing should be nil, 
    # otherwise not save
    tokujo_with_immediate.payment_collection_timing = :immediate
    tokujo_with_immediate.ingredients_procurement_time = 3
    tokujo_with_immediate.ingredients_expiration_time = 10
    tokujo_with_immediate.order_period_starts_at = Time.now + 1.days # Needs to be >= to current time, so add 1 day
    tokujo_with_immediate.order_period_ends_at = Time.now + 5.days
    tokujo_with_immediate.eat_period_starts_at = Time.now + 5.days + 3.days
    tokujo_with_immediate.eat_period_ends_at = Time.now + 5.days + 3.days + 10.days
    tokujo_with_immediate.number_of_items_available = 100

    tokujo_with_delayed = Tokujo.new
    tokujo_with_delayed.user_id = @user.id
    tokujo_with_delayed.headline = "headline for delayed"
    tokujo_with_delayed.menu_item_id = @menu_item.id
    # Delayed payment collection timing, so the values for attributes
    # related to this value for payment collection timing should not be nil, 
    # otherwise not save
    tokujo_with_delayed.payment_collection_timing = :delayed
    tokujo_with_delayed.ingredients_procurement_time = nil
    tokujo_with_delayed.ingredients_expiration_time = nil
    tokujo_with_delayed.order_period_starts_at = nil # Needs to be >= to current time, so add 1 day
    tokujo_with_delayed.order_period_ends_at = nil
    tokujo_with_delayed.eat_period_starts_at = nil
    tokujo_with_delayed.eat_period_ends_at = nil
    tokujo_with_delayed.number_of_items_available = nil

    assert_not tokujo_with_immediate.save
    assert_not tokujo_with_delayed.save
  end

  test "should save a record with valid attributes related to payment collection timing value of delayed" do
    tokujo_with_immediate = Tokujo.new
    tokujo_with_immediate.user_id = @user.id
    tokujo_with_immediate.headline = "headline for immediate"
    tokujo_with_immediate.menu_item_id = @menu_item.id
    tokujo_with_immediate.payment_collection_timing = :immediate

    tokujo_with_delayed = Tokujo.new
    tokujo_with_delayed.user_id = @user.id
    tokujo_with_delayed.headline = "headline for delayed"
    tokujo_with_delayed.menu_item_id = @menu_item.id
    tokujo_with_delayed.payment_collection_timing = :delayed
    tokujo_with_delayed.ingredients_procurement_time = 3
    tokujo_with_delayed.ingredients_expiration_time = 10
    tokujo_with_delayed.order_period_starts_at = Time.now + 1.days # Needs to be >= to current time, so add 1 day
    tokujo_with_delayed.order_period_ends_at = Time.now + 5.days
    tokujo_with_delayed.eat_period_starts_at = Time.now + 5.days + 3.days
    tokujo_with_delayed.eat_period_ends_at = Time.now + 5.days + 3.days + 9.days
    tokujo_with_delayed.number_of_items_available = 100

    assert tokujo_with_immediate.save
    assert tokujo_with_delayed.save
  end

  # Callbacks
  test "should set default value for number_of_items_taken if payment_collection_timing value is delayed" do
    tokujo_with_delayed = Tokujo.new
    tokujo_with_delayed.user_id = @user.id
    tokujo_with_delayed.headline = "another catchy headline"
    tokujo_with_delayed.menu_item_id = @menu_item.id
    tokujo_with_delayed.payment_collection_timing = :delayed
    tokujo_with_delayed.ingredients_procurement_time = 3
    tokujo_with_delayed.ingredients_expiration_time = 10
    tokujo_with_delayed.order_period_starts_at = Time.now + 1.days # Needs to be >= to current time, so add 1 day
    tokujo_with_delayed.order_period_ends_at = Time.now + 5.days
    tokujo_with_delayed.eat_period_starts_at = Time.now + 5.days + 3.days
    tokujo_with_delayed.eat_period_ends_at = Time.now + 5.days + 3.days + 9.days
    tokujo_with_delayed.number_of_items_available = 100

    assert tokujo_with_delayed.save
    assert_equal 0, tokujo_with_delayed.number_of_items_taken
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
