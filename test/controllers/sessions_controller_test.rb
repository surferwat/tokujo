require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_one)
  end

  test "should get new" do
    get session_new_url
    assert_response :success
  end

  test "should create session with valid credentials" do
    post sessions_url, params: { email: @user.email, password: "password" }
    assert_redirected_to dashboard_path
    assert_equal @user.id, session[:user_id]
  end

  test "should not create session with invalid credentials" do
    post sessions_url, params: { email: @user.email, password: "wrong_password" }
    assert_response :unprocessable_entity
    assert_nil session[:user_id]
  end

  test "should destroy session" do
    sign_in(@user)
    delete session_url
    assert_redirected_to root_path
    assert_nil session[:user_id]
  end

  private 
  
  def sign_in(user)
    post sessions_url, params: { email: user.email, password: 'password' }
  end
end
