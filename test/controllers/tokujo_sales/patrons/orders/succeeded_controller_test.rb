require "test_helper"

class TokujoSales::Patrons::Orders::SucceededControllerTest < ActionDispatch::IntegrationTest
  setup do 
    @checkout_session = checkout_sessions(:checkout_session_one)
    @tokujo = tokujos(:tokujo_one)
    @user_patron = user_patrons(:user_patron_one)
    @order = orders(:order_one)
  end
  
  test "should get index" do
    get tokujo_sales_patrons_orders_succeeded_path(@tokujo.id, @user_patron.id, @order.id, checkout_session_id: @checkout_session.id)
    assert_response :success
  end

  test "should not get index without checkout_session_id" do
    get tokujo_sales_patrons_orders_succeeded_path(@tokujo.id, @user_patron.id, @order.id, checkout_session_id: "")
    assert_redirected_to tokujo_sale_path(tokujo_id: @tokujo.id)
  end
end
