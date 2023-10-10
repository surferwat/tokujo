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

  test "should update order item_status and status and tokujo status when payment collection timing value is immediate" do
    tokujo_immediate = tokujos(:tokujo_two)

    get tokujo_sale_orders_succeeded_path(@order.id, tokujo_id: tokujo_immediate.id, patron_id: @user_patron.id, checkout_session_id: @checkout_session.id)

    @order.reload
    tokujo_immediate.reload

    assert_equal @order.item_status, "payment_received"
    assert_equal @order.status, "closed"
    assert_equal tokujo_immediate.status, "closed"
  end

  test "should update order item_status and status and tokujo number_of_items_taken when payment collection timing value is delayed" do
    tokujo_delayed = tokujos(:tokujo_one)

    tokujo_number_of_items_taken = tokujo_delayed.number_of_items_taken

    get tokujo_sale_orders_succeeded_path(@order.id, tokujo_id: tokujo_delayed.id, patron_id: @user_patron.id, checkout_session_id: @checkout_session.id)

    @order.reload
    tokujo_delayed.reload

    assert_equal @order.item_status, "payment_due"
    assert_equal tokujo_delayed.number_of_items_taken, tokujo_number_of_items_taken + @order.size
  end

  test "should destroy checkout session" do
    get tokujo_sale_orders_succeeded_path(@order.id, tokujo_id: @tokujo.id, patron_id: @user_patron.id, checkout_session_id: @checkout_session.id)
    
    assert_not CheckoutSession.exists?(@checkout_session.id)
    assert_response :success
  end
end