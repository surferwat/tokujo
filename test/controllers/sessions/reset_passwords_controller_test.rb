require 'test_helper'

class Sessions::ResetPasswordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_one)
  end

  test "should get edit" do
    get sessions_reset_password_edit_path(token: "sample_token")
    assert_response :success
  end

  test "should update password with valid reset token" do
    token = "valid_token"
    @user.update(password_reset_token: token)

    patch sessions_reset_password_update_path(token: token), params: {
      password: "new_password",
      password_confirmation: "new_password"
    }

    assert_redirected_to root_path
    assert_equal "Password successfully reset", flash[:notice]
  end

  test "should render edit with invalid reset token" do
    token = "invalid_token"

    patch sessions_reset_password_update_path(token: token), params: {
      password: "new_password",
      password_confirmation: "new_password"
    }

    assert_response :unprocessable_entity
  end
end
