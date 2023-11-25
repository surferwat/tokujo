require "test_helper"

class Dashboards::TokujosControllerTest < ActionDispatch::IntegrationTest
  # For index
  test "should get index" do
    user = users(:user_one)
    sign_in(user)
    get tokujos_url
    assert_response :success
  end

  private 
  
  def sign_in(user)
    post session_new_url, params: { email: user.email, password: 'password' }
  end
end
