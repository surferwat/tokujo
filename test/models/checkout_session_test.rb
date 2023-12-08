require "test_helper"

class CheckoutSessionTest < ActiveSupport::TestCase
  def setup
    @user_patron = user_patrons(:user_patron_one)
    @order = orders(:order_one)
  end

  # Associations
  test "should not require user_patron_id on creation" do
    checkout_session = CheckoutSession.create
    assert_nil checkout_session.user_patron_id
    assert_not_nil checkout_session
  end

  test "should not require order_id on creation" do
    checkout_session = CheckoutSession.create
    assert_nil checkout_session.order_id
    assert_not_nil checkout_session
  end

  test "should be able to associate user_patron_id after creation" do
    checkout_session = CheckoutSession.create
    checkout_session.user_patron_id = @user_patron.id
    assert_equal checkout_session.user_patron_id, @user_patron.id
  end

  test "should be able to associate order_id after creation" do
    checkout_session = CheckoutSession.create
    checkout_session.order_id = @order.id
    assert_equal checkout_session.order_id, @order.id
  end

  # Validations
  test "combination of user_patron_id and order_id must be unique" do
    existing_checkout_session = CheckoutSession.create(user_patron_id: @user_patron.id, order_id: @order.id)
    new_checkout_session = CheckoutSession.create(user_patron_id: @user_patron.id, order_id: @order.id)
    assert_not new_checkout_session.valid?
  end
end
