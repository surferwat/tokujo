require "test_helper"

class TokujoSalesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tokujo_delayed = tokujos(:tokujo_one)
    @tokujo_immediate = tokujos(:tokujo_two)
  end

  test "should get show" do
    get tokujo_sale_url(tokujo_id: @tokujo_delayed.id)
    assert_response :success
  end

  test "should create checkout session" do
    assert_difference("CheckoutSession.count") do
      get tokujo_sale_url(tokujo_id: @tokujo_delayed.id)
    end
  end

  test "should render show_for_delayed" do
    get tokujo_sale_url(tokujo_id: @tokujo_delayed)
    assert_template :show_for_delayed
  end

  test "should render show_for_immediate" do
    get tokujo_sale_url(tokujo_id: @tokujo_immediate)
    assert_template :show_for_immediate
  end
end