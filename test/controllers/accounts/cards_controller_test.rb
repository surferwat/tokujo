require "test_helper"

class Accounts::CardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_one)
  end

  test "should get index if signed in" do
    sign_in(@user)
    get accounts_cards_path
    assert_response :success
  end

  test "should not get index if signed out" do
    assert_raises Pundit::NotAuthorizedError do
      get accounts_cards_path
    end
  end

  private 
  
  def sign_in(user)
    post sessions_url, params: { email: user.email, password: 'password' }
  end
end
