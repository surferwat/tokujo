require "test_helper"

class BusinessInformationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get business_informations_path
    assert_response :success
  end
end
