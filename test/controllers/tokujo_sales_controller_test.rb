require "test_helper"

class TokujoSalesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    tokujo = tokujos(:tokujo_one)
    
    assert_difference("CheckoutSession.count") do
      get tokujo_sale_url(tokujo_id: tokujo.id)
    end
    assert_response :success
  end
end