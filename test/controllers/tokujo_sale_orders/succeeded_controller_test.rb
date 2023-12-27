require "test_helper"

class TokujoSaleOrders::SucceededControllerTest < ActionDispatch::IntegrationTest
  setup do 
    @checkout_session = checkout_sessions(:checkout_session_one)
    @tokujo = tokujos(:tokujo_one)
    @user_patron = user_patrons(:user_patron_one)
    @order = orders(:order_one)
  end
  


  test "should get index" do
    get tokujo_sale_orders_succeeded_path(@order.id, tokujo_id: @tokujo.id, patron_id: @user_patron.id, checkout_session_id: @checkout_session.id)
    assert_response :success
  end



  test "should not get index without checkout_session_id" do
    get tokujo_sale_orders_succeeded_path(@order.id, tokujo_id: @tokujo.id, patron_id: @user_patron.id, checkout_session_id: "")
    assert_redirected_to tokujo_sale_path(tokujo_id: @tokujo.id)
  end



  test "should get index despite checkout_session soft deleted since current time - checkout_session.deleted_at < 1 minute" do
    # Create checkout session
    checkout_session = CheckoutSession.create(user_patron_id: @user_patron.id, order_id: nil)

    # Create order
    order = Order.create(size: 8, payment_amount_base: 108, payment_amount_currency: "USD", tokujo_id: @tokujo.id, user_patron_id: @user_patron.id)

    # Update checkout session
    checkout_session.update_column(:order_id, order.id)

    # Delete checkout session
    checkout_session.update_column(:deleted_at, Time.now)

    get tokujo_sale_orders_succeeded_path(@order.id, tokujo_id: @tokujo.id, patron_id: @user_patron.id, checkout_session_id: checkout_session.id)
    assert_response :success
  end



  test "should not get index when checkout_session soft deleted and current time - checkout_session.deleted_at >= 1 minute" do
    # Create checkout session
    checkout_session = CheckoutSession.create(user_patron_id: @user_patron.id, order_id: nil)

    # Create order
    order = Order.create(size: 8, payment_amount_base: 108, payment_amount_currency: "USD", tokujo_id: @tokujo.id, user_patron_id: @user_patron.id)

    # Update checkout session
    checkout_session.update_column(:order_id, order.id)

    # Delete checkout session
    checkout_session.update_column(:deleted_at, Time.now - 1.minute)

    get tokujo_sale_orders_succeeded_path(@order.id, tokujo_id: @tokujo.id, patron_id: @user_patron.id, checkout_session_id: checkout_session.id)
    assert_redirected_to tokujo_sale_path(tokujo_id: @tokujo.id)
  end
end