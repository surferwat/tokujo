require "test_helper"

class Accounts::Cards::OnboardingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_one)
  end

  test "should get index if signed in" do
    sign_in(@user)
    get accounts_cards_onboardings_path
    assert_response :redirect
  end

  test "should not get index if signed out" do
    assert_raises Pundit::NotAuthorizedError do
      get accounts_cards_onboardings_path
    end
  end

  private 
  
  def sign_in(user)
    post sessions_url, params: { email: user.email, password: 'password' }
  end
end
