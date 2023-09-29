require "test_helper"

class Accounts::CancellationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_one)
  end

  test "should get new" do
    sign_in(@user)
    get accounts_cancellations_new_url
    assert_response :success
  end

  test "should create cancellation and redirect to root path with notice" do
    user = User.create(
      email: "test@example.com",
      username: "test_user",
      created_at: Time.now,
      updated_at: Time.now,
      password_digest: BCrypt::Password.create('password'),
      stripe_customer_id: "cus_stripe123"
    )
    sign_in(user)

    assert_difference('Cancellation.count',1) do
      assert_difference('User.count', -1) do
        post accounts_cancellations_url
      end
    end
    assert_redirected_to root_path
    assert_equal "Your account has been cancelled", flash[:notice]
  end
  
  private 
  
  def sign_in(user)
    post session_new_url, params: { email: user.email, password: 'password' }
  end
end