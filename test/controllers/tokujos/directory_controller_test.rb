require "test_helper"

class Tokujos::DirectoryControllerTest < ActionDispatch::IntegrationTest
  setup do 
    @user = users(:user_one)
  end

  test "should get index" do
    sign_in(@user)
    get tokujos_directory_url
    assert_response :success
  end

  private 
  
  def sign_in(user)
    post session_new_url, params: { email: user.email, password: 'password' }
  end
end
