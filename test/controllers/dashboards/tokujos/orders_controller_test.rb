require "test_helper"

class Dashboards::Tokujos::OrdersControllerTest < ActionDispatch::IntegrationTest
  # For index
  test "should get index" do
    tokujo = tokujos(:tokujo_one)
    user = users(:user_one)
    sign_in(user)
    get dashboards_tokujos_orders_path(tokujo.id)
    assert_response :success
  end



  # For show
  test "should get show" do
    tokujo = tokujos(:tokujo_one)
    order = orders(:order_one)
    user = users(:user_one)
    sign_in(user)
    get dashboards_tokujos_order_path(tokujo.id, order.id)
    assert_response :success
  end



  private 
  


  def sign_in(user)
    post session_new_url, params: { email: user.email, password: 'password' }
  end
end
