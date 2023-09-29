require "test_helper"

class TokujoSales::PatronsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @checkout_session = checkout_sessions(:checkout_session_one)
    @tokujo = tokujos(:tokujo_one)
    @user_patron = user_patrons(:user_patron_one)
  end

  test "should get new" do
    get tokujo_sales_new_patron_path(@tokujo.id, checkout_session_id: @checkout_session.id)
    assert_response :success
  end

  test "should not get new without checkout_session_id" do
    get tokujo_sales_new_patron_path(@tokujo.id, checkout_session_id: "")
    assert_redirected_to tokujo_sale_path(tokujo_id: @tokujo.id)
  end

  test "should create patron" do
    assert_difference("UserPatron.count") do
      post tokujo_sales_patrons_url(tokujo_id: @tokujo.id, checkout_session_id: @checkout_session.id),
        params: {
          user_patron: {
            email: "email@test.com",
          },
        }
    end

    assert_redirected_to tokujo_sales_patrons_new_order_path(tokujo_id: @tokujo.id, patron_id: UserPatron.last, checkout_session_id: @checkout_session.id)
  end

  test "should not create patron without checkout_session_id" do
    assert_no_difference("UserPatron.count") do
      post tokujo_sales_patrons_url(tokujo_id: @tokujo.id, checkout_session_id: ""),
        params: {
          user_patron: {
            email: "email@test.com",
          },
        }
    end

    assert_redirected_to tokujo_sale_path(tokujo_id: @tokujo.id)
  end
end
