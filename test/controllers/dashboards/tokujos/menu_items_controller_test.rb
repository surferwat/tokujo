require "test_helper"

class Dashboards::Tokujos::MenuItemsControllerTest < ActionDispatch::IntegrationTest
  # For index
  test "should get index" do
    tokujo = tokujos(:tokujo_one)
    user = users(:user_one)
    sign_in(user)
    get dashboard_tokujos_menu_items_url(tokujo.id)
    assert_response :success
  end



  private 
  

  
  def sign_in(user)
    post session_new_url, params: { email: user.email, password: 'password' }
  end
end
