require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user_params = {
      user: {
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      }
    }
  end
  
  test "should get new" do
    get sign_up_new_path
    assert_response :success
  end

  # test "should create user and redirect to root_path" do
  #   assert_difference("User.count") do
  #     post sign_ups_path, params: @user_params
  #   end

  #   assert_redirected_to root_path
  #   assert_equal "Successfully created account", flash[:notice]
  # end

  # test "should render new with errors if user creation fails" do
  #   @user_params[:user][:password_confirmation] = "different_password"
  #   post sign_ups_path, params: @user_params
  #   assert_response :unprocessable_entity
  # end
end
