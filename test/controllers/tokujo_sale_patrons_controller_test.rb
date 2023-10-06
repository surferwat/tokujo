require "test_helper"

class TokujoSalePatronsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @checkout_session = checkout_sessions(:checkout_session_one)
    @tokujo = tokujos(:tokujo_one)
    @user_patron = user_patrons(:user_patron_one)
    @size = 8
    @total_price_with_tax = 108
  end



  test "should get new" do
    get new_tokujo_sale_patron_path(tokujo_id: @tokujo.id, checkout_session_id: @checkout_session.id, size: @size)
    assert_response :success
  end



  test "should not get new without checkout_session_id" do
    get new_tokujo_sale_patron_path(tokujo_id: @tokujo.id, checkout_session_id: "", size: @size)
    assert_redirected_to tokujo_sale_path(tokujo_id: @tokujo.id)
  end



  test "should create patron" do
    assert_difference("UserPatron.count") do
      post tokujo_sale_patrons_url(tokujo_id: @tokujo.id, checkout_session_id: @checkout_session.id, size: @size, total_price_with_tax: @total_price_with_tax),
        params: {
          user_patron: {
            email: "email@test.com",
          },
        }
    end
    assert_redirected_to new_tokujo_sale_order_path(tokujo_id: @tokujo.id, patron_id: UserPatron.last, checkout_session_id: @checkout_session.id, size: @size, total_price_with_tax: @total_price_with_tax)
  end



  test "should not create patron without checkout_session_id" do
    assert_no_difference("UserPatron.count") do
      post tokujo_sale_patrons_url(tokujo_id: @tokujo.id, checkout_session_id: "", size: @size, total_price_with_tax: @total_price_with_tax),
        params: {
          user_patron: {
            email: "email@test.com",
          },
        }
    end
    assert_redirected_to tokujo_sale_path(tokujo_id: @tokujo.id)
  end



  test "should assign value for checkout_session.user_patron_id, if checkout_session.user_patron_id is nil" do
    assert_nil @checkout_session.user_patron_id 
    
    post tokujo_sale_patrons_url(tokujo_id: @tokujo.id, checkout_session_id: @checkout_session.id, size: @size, total_price_with_tax: @total_price_with_tax),
    params: {
      user_patron: {
        email: "email@test.com",
      },
    }
    @checkout_session.reload

    assert_equal UserPatron.last.id, @checkout_session.user_patron_id
    assert_redirected_to new_tokujo_sale_order_path(tokujo_id: @tokujo.id, patron_id: UserPatron.last, checkout_session_id: @checkout_session.id, size: @size, total_price_with_tax: @total_price_with_tax)
  end



  test "should update checkout_session.user_patron_id, if it is not nil but different UserPatron object" do
    checkout_session = CheckoutSession.create(user_patron_id: nil, order_id: nil)
    
    email =  "user_patron@example.com"
    user_patron = UserPatron.create(email: email, stripe_customer_id: "cus_tokujo_sale_patrons_1")
    checkout_session.user_patron_id = user_patron.id
    checkout_session.save

    order = Order.create(tokujo_id: @tokujo.id, user_patron_id: user_patron.id, size: @size, payment_amount_cents: 100)
    checkout_session.order_id = order.id
    checkout_session.save

    different_email = "different_user_patron@example.com"
    different_user_patron = UserPatron.create(email: different_email, stripe_customer_id: "cus_tokujo_sale_patrons_2")

    assert_equal checkout_session.user_patron_id, user_patron.id   

    post tokujo_sale_patrons_url(
      tokujo_id: @tokujo.id, checkout_session_id: checkout_session.id, size: @size, total_price_with_tax: @total_price_with_tax),
    params: {
      user_patron: {
        email: different_email,
      },
    }
    checkout_session.reload

    assert_equal checkout_session.user_patron_id, different_user_patron.id
    assert_redirected_to new_tokujo_sale_order_path(tokujo_id: @tokujo.id, patron_id: different_user_patron.id, checkout_session_id: checkout_session.id, size: @size, total_price_with_tax: @total_price_with_tax)
  end


  
  test "should not update checkout_session.user_patron_id, if it is not nil but same UserPatron object" do
    checkout_session = CheckoutSession.create(user_patron_id: nil, order_id: nil)
    
    email =  "user_patron@example.com"
    user_patron = UserPatron.create(email: email, stripe_customer_id: "cus_tokujo_sale_patrons_1")
    checkout_session.user_patron_id = user_patron.id
    checkout_session.save

    order = Order.create(tokujo_id: @tokujo.id, user_patron_id: user_patron.id, size: @size, payment_amount_cents: 100)
    checkout_session.order_id = order.id
    checkout_session.save

    assert_equal checkout_session.user_patron_id, user_patron.id   
     
    post tokujo_sale_patrons_url(tokujo_id: @tokujo.id, checkout_session_id: checkout_session.id, size: @size, total_price_with_tax: @total_price_with_tax),
    params: {
      user_patron: {
        email: email,
      },
    }
    checkout_session.reload

    assert_equal checkout_session.user_patron_id, user_patron.id
    assert_redirected_to new_tokujo_sale_order_path(tokujo_id: @tokujo.id, patron_id: user_patron.id, checkout_session_id: checkout_session.id, size: @size, total_price_with_tax: @total_price_with_tax)
  end
end
