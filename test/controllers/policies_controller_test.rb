require "test_helper"

class PoliciesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get policies_path
    assert_response :success
  end
end
