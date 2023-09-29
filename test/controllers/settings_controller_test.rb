require "test_helper"

class SettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_one)
  end

  test "should get index" do
    sign_in(@user)
    get settings_path
    assert_response :success
  end

  private 
  
  def sign_in(user)
    post sessions_url, params: { email: user.email, password: 'password' }
  end
end
