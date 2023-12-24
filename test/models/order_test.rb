require "test_helper"

class OrderTest < ActiveSupport::TestCase
  def setup
    @order = orders(:order_one)
    @tokujo = tokujos(:tokujo_one)
    @user_patron = user_patrons(:user_patron_one)
  end

  # Validations
  test "should be valid" do
    assert @order.valid?
  end

  test "size should be present and greater than 0" do
    @order.size = ""
    assert_not @order.valid?

    @order.size = 0
    assert_not @order.valid?

    @order.size = -1
    assert_not @order.valid?

    @order.size = 9.99
    assert @order.valid?
  end

  test "payment_amount_base should be present and greater than 0" do
    @order.payment_amount_base = ""
    assert_not @order.valid?

    @order.payment_amount_base = 0
    assert_not @order.valid?

    @order.payment_amount_base = -1
    assert_not @order.valid?

    @order.payment_amount_base = 9.99
    assert @order.valid?
  end

  test "status should be present" do
    @order.status = ""
    assert_not @order.valid?
  end

  test "item status should be present" do
    @order.item_status = ""
    assert_not @order.valid?
  end

  test "tokujo id should be present" do
    @order.tokujo_id = ""
    assert_not @order.valid?
  end

  test "payment_amount_currency should be present" do
    @order.payment_amount_currency = ""
    assert_not @order.valid?
  end

  test "should create new instance when tokujo is open" do
    order = Order.new(size: 1, payment_amount_base: 10000, payment_amount_currency: "USD", tokujo_id: @tokujo.id, user_patron_id: @user_patron.id)
    order.save
    assert order.valid?
  end

  test "should not create new instance when tokujo is closed" do    
    @tokujo.status = 1
    @tokujo.save
    order = Order.new(size: 1, payment_amount_base: 10000, payment_amount_currency: "USD", tokujo_id: @tokujo.id, user_patron_id: @user_patron.id)
    order.save
    refute order.valid?
    assert_includes order.errors[:tokujo_id], "is closed"
  end

  test "should not create new instance when payment_amount_currency does not match tokujo.menu_item.currency" do
    order = Order.new(size: 1, payment_amount_base: 10000, payment_amount_currency: "JPY", tokujo_id: @tokujo.id, user_patron_id: @user_patron.id)

    refute order.valid?
    assert_includes order.errors[:payment_amount_currency], "must match the currency of the underlying menu item"
  end

  # Associations
  test "should belong to user_patron" do
    assert_respond_to @order, :user_patron
  end

  test "should belong to tokujo" do
    assert_respond_to @order, :tokujo
  end

  # Enums
  test "enum status work as expected" do
    @order.status = "open"
    @order.save
    assert @order.open?
    refute @order.canceled?
    refute @order.expired?
    refute @order.closed?

    @order.status = "canceled"
    @order.save
    refute @order.open?
    assert @order.canceled?
    refute @order.expired?
    refute @order.closed?

    @order.status = "expired"
    @order.save
    refute @order.open?
    refute @order.canceled?
    assert @order.expired?
    refute @order.closed?

    @order.status = "closed"
    @order.save
    refute @order.open?
    refute @order.canceled?
    refute @order.expired?
    assert @order.closed?
  end

  test "enum item_status work as expected" do
    @order.item_status = :payment_method_required
    @order.save
    assert @order.payment_method_required?
    refute @order.payment_due?
    refute @order.payment_received?

    @order.item_status = :payment_due
    @order.save
    refute @order.payment_method_required?
    assert @order.payment_due?
    refute @order.payment_received?

    @order.item_status = :payment_received
    @order.save
    refute @order.payment_method_required?
    refute @order.payment_due?
    assert @order.payment_received?
  end
end
