require "test_helper"

class Settings::PasswordsControllerTest < ActionDispatch::IntegrationTest
  # Sets up the test environment
  setup do
    @user = users(:user_one)
  end

  # Tests the edit action
  test "should get edit" do
    sign_in(@user)
    get settings_password_edit_url
    assert_response :success
  end

  # Tests the update action with valid params
  test "should update profile with valid params" do
    sign_in(@user)
    patch settings_passwords_update_url, params: { user: { 
      password: "new_password",
      password_confirmation: "new_password",
    } }
    assert_redirected_to settings_profile_edit_url
    assert_equal "Password updated", flash[:notice]
  end

  private 
  
  def sign_in(user)
    post sessions_url, params: { email: user.email, password: 'password' }
  end
end
