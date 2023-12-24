require "test_helper"

class TokujoSaleOrdersControllerTest < ActionDispatch::IntegrationTest
  setup do 
    @checkout_session = checkout_sessions(:checkout_session_one)
    @tokujo = tokujos(:tokujo_one)
    @user_patron = user_patrons(:user_patron_one)
  end
  


  test "should get new" do
    get new_tokujo_sale_order_path(tokujo_id: @tokujo.id, patron_id: @user_patron.id, checkout_session_id: @checkout_session.id, size: 8, total_price_with_tax: 10000)
    assert_response :success
  end



  test "should not get new without checkout_session_id" do
    get new_tokujo_sale_order_path(tokujo_id: @tokujo.id, patron_id: @user_patron.id, checkout_session_id:  "", size: 8, total_price_with_tax: 10000)
    assert_redirected_to tokujo_sale_path(tokujo_id: @tokujo.id)
  end



  test "should create new order and update checkout_session, if there is no existing order tied to this checkout session" do  
    assert_nil @checkout_session.order_id

    assert_difference("Order.count") do
      post tokujo_sale_orders_url(tokujo_id: @tokujo.id, patron_id: @user_patron.id, checkout_session_id: @checkout_session.id),
        params: {
          order: {
            size: 8,
            payment_amount: 10000,
            payment_amount_currency: "USD",
            tokujo_id: @tokujo.id
          },
        }
    end
    
    @checkout_session.reload

    assert_equal @checkout_session.order_id, Order.last.id
    assert_redirected_to tokujo_sale_orders_card_setups_path(tokujo_id: @tokujo.id, patron_id: @user_patron.id, id: Order.last, checkout_session_id: @checkout_session.id)
  end



  test "should not create new order and not update checkout_session, if there is an existing order already tied to this checkout session" do  
    order = Order.create(size: 8, payment_amount_base: 108, payment_amount_currency: "USD", tokujo_id: @tokujo.id, user_patron_id: @user_patron.id)
    @checkout_session.order_id = order.id
    @checkout_session.save

    assert_not_nil @checkout_session.order_id

    assert_no_difference("Order.count") do
      post tokujo_sale_orders_url(tokujo_id: @tokujo.id, patron_id: @user_patron.id, checkout_session_id: @checkout_session.id),
        params: {
          order: {
            size: 8,
            payment_amount: 10000,
            payment_amount_currency: "USD",
            tokujo_id: @tokujo.id
          },
        }
    end
    
    @checkout_session.reload

    assert_equal @checkout_session.order_id, order.id
    assert_redirected_to tokujo_sale_orders_card_setups_path(tokujo_id: @tokujo.id, patron_id: @user_patron.id, id: @checkout_session.order_id, checkout_session_id: @checkout_session.id)
  end


  
  test "should redirect to card payments path for immediate charge" do  
    @tokujo_immediate = tokujos(:tokujo_two)

    post tokujo_sale_orders_url(tokujo_id: @tokujo_immediate.id, patron_id: @user_patron.id, checkout_session_id: @checkout_session.id),
      params: {
        order: {
          size: 8,
          payment_amount: 10000,
          payment_amount_currency: "USD",
          tokujo_id: @tokujo_immediate.id
        },
      }

    assert_redirected_to tokujo_sale_orders_card_payments_path(tokujo_id: @tokujo_immediate.id, patron_id: @user_patron.id, id: Order.last, checkout_session_id: @checkout_session.id)
  end



  test "should redirect to card payments path for delayed charge" do  
    @tokujo_delayed = tokujos(:tokujo_one)

    post tokujo_sale_orders_url(tokujo_id: @tokujo_delayed.id, patron_id: @user_patron.id, checkout_session_id: @checkout_session.id),
      params: {
        order: {
          size: 8,
          payment_amount: 10000,
          payment_amount_currency: "USD",
          tokujo_id: @tokujo_delayed.id
        },
      }

    assert_redirected_to tokujo_sale_orders_card_setups_path(tokujo_id: @tokujo_delayed.id, patron_id: @user_patron.id, id: Order.last, checkout_session_id: @checkout_session.id)
  end



  test "should not create order without checkout_session_id" do
    assert_no_difference("Order.count") do
      post tokujo_sale_orders_url(tokujo_id: @tokujo.id, patron_id: @user_patron.id, checkout_session_id: ""),
        params: {
          order: {
            size: 8,
            payment_amount: 10000,
            payment_amount_currency: "USD",
            tokujo_id: @tokujo.id
          },
        }
    end

    assert_redirected_to tokujo_sale_path(tokujo_id: @tokujo.id)
  end  
end