require "test_helper"

class MenuItemsControllerTest < ActionDispatch::IntegrationTest
  setup do 
    @user = users(:user_one)
  end


  
  # For index
  test "should get index" do
    sign_in(@user)
    get menu_items_url
    assert_response :success
  end



  private



  def sign_in(user)
    post session_new_url, params: { email: user.email, password: 'password' }
  end
end
