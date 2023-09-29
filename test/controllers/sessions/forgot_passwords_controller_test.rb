require 'test_helper'

class Sessions::ForgotPasswordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_one)
  end

  test "should get new" do
    get sessions_forgot_password_new_path
    assert_response :success
  end

  test "should create forgot password" do
    post sessions_forgot_password_path, params: { user: { email: @user.email } }
    assert_redirected_to root_path
    assert_equal "Check your email for reset instructions", flash[:notice]
  end
end
