require "test_helper"

class EarliesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_early_url
    assert_response :success
  end



  test "should create early" do
    post earlies_url, params: { early: { email: "test@example.com" } }
    assert_response :success
  end
end
