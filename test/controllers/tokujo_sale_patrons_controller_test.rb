require "test_helper"

class TokujoSalePatronsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @checkout_session = checkout_sessions(:checkout_session_one)
    @tokujo = tokujos(:tokujo_one)
    @user_patron = user_patrons(:user_patron_one)
  end

  test "should get new" do
    get new_tokujo_sale_patron_path(tokujo_id: @tokujo.id, checkout_session_id: @checkout_session.id, size: 8)
    assert_response :success
  end

  test "should not get new without checkout_session_id" do
    get new_tokujo_sale_patron_path(tokujo_id: @tokujo.id, checkout_session_id: "", size: 8)
    assert_redirected_to tokujo_sale_path(tokujo_id: @tokujo.id)
  end

  test "should create patron" do
    assert_difference("UserPatron.count") do
      post tokujo_sale_patrons_url(tokujo_id: @tokujo.id, checkout_session_id: @checkout_session.id),
        params: {
          user_patron: {
            email: "email@test.com",
          },
        }
    end

    assert_redirected_to new_tokujo_sale_order_path(tokujo_id: @tokujo.id, patron_id: UserPatron.last, checkout_session_id: @checkout_session.id)
  end

  test "should not create patron without checkout_session_id" do
    assert_no_difference("UserPatron.count") do
      post tokujo_sale_patrons_url(tokujo_id: @tokujo.id, checkout_session_id: ""),
        params: {
          user_patron: {
            email: "email@test.com",
          },
        }
    end

    assert_redirected_to tokujo_sale_path(tokujo_id: @tokujo.id)
  end
end
