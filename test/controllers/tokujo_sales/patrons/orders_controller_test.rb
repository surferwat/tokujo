require "test_helper"

class TokujoSales::Patrons::OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do 
    @checkout_session = checkout_sessions(:checkout_session_one)
    @tokujo = tokujos(:tokujo_one)
    @user_patron = user_patrons(:user_patron_one)
  end
  
  test "should get new" do
    get tokujo_sales_patrons_new_order_path(@tokujo.id, @user_patron.id, checkout_session_id: @checkout_session.id, size: 8, total_price_with_tax: 10000)
    assert_response :success
  end

  test "should not get new without checkout_session_id" do
    get tokujo_sales_patrons_new_order_path(@tokujo.id, @user_patron.id, checkout_session_id:  "", size: 8, total_price_with_tax: 10000)
    assert_redirected_to tokujo_sale_path(tokujo_id: @tokujo.id)
  end

  test "should create order" do
    assert_difference("Order.count") do
      post tokujo_sales_patrons_orders_url(tokujo_id: @tokujo.id, patron_id: @user_patron.id, checkout_session_id: @checkout_session.id),
        params: {
          order: {
            size: 8,
            payment_amount: 10000,
            tokujo_id: @tokujo.id
          },
        }
    end

    assert_redirected_to tokujo_sales_patrons_orders_card_setups_path(tokujo_id: @tokujo.id, patron_id: @user_patron.id, id: Order.last, checkout_session_id: @checkout_session.id)
  end

  test "should not create order without checkout_session_id" do
    assert_no_difference("Order.count") do
      post tokujo_sales_patrons_orders_url(tokujo_id: @tokujo.id, patron_id: @user_patron.id, checkout_session_id: ""),
        params: {
          order: {
            size: 8,
            payment_amount: 10000,
            tokujo_id: @tokujo.id
          },
        }
    end

    assert_redirected_to tokujo_sale_path(tokujo_id: @tokujo.id)
  end
end
