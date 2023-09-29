require "test_helper"

class Settings::ProfilesControllerTest < ActionDispatch::IntegrationTest
  # Sets up the test environment
  setup do
    @user = users(:user_one)
  end

  # Tests the edit action
  test "should get edit" do
    sign_in(@user)
    get settings_profile_edit_url
    assert_response :success
  end

  # Tests the update action with valid params
  test "should update profile with valid params" do
    sign_in(@user)
    patch settings_profiles_update_url, params: { user: { 
      username: "new_username",
    } }
    assert_redirected_to settings_profile_edit_url
    assert_equal "Profile updated", flash[:notice]
  end

  private 
  
  def sign_in(user)
    post sessions_url, params: { email: user.email, password: 'password' }
  end
end
