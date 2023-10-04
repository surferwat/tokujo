require "test_helper"

class TokujoSaleOrders::CardSetupsControllerTest < ActionDispatch::IntegrationTest
  setup do 
    @checkout_session = checkout_sessions(:checkout_session_one)
    @tokujo = tokujos(:tokujo_one)
    @stripe_customer_id = StripeApiCaller::Customer.new.create_customer.id
    @user_patron = UserPatron.create(email: "email@test.com", stripe_customer_id: @stripe_customer_id)
    @order = Order.create(user_patron_id: @user_patron.id, size: 8, payment_amount: 10000, tokujo_id: @tokujo.id)
  end
  
  test "should get index" do
    get tokujo_sale_orders_card_setups_path(@order.id, tokujo_id: @tokujo.id, patron_id: @user_patron.id, checkout_session_id: @checkout_session.id)
    assert_response :success
  end

  test "should not get index without checkout_session_id" do
    get tokujo_sale_orders_card_setups_path(@order.id, tokujo_id: @tokujo.id, patron_id: @user_patron.id, checkout_session_id: "")
    assert_redirected_to tokujo_sale_path(tokujo_id: @tokujo.id)
  end
end
