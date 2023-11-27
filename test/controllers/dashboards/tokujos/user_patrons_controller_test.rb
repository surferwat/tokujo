require "test_helper"

class Dashboards::Tokujos::UserPatronsControllerTest < ActionDispatch::IntegrationTest
  # For index
  test "should get index" do
    tokujo = tokujos(:tokujo_one)
    user = users(:user_one)
    sign_in(user)
    get dashboard_tokujos_user_patrons_url(tokujo.id)
    assert_response :success
  end



  # For show
  test "should get show" do
    tokujo = tokujos(:tokujo_one)
    user_patron = user_patrons(:user_patron_one)
    user = users(:user_one)
    sign_in(user)
    get dashboard_tokujos_user_patron_path(tokujo.id, user_patron.id)
    assert_response :success
  end



  private 
  


  def sign_in(user)
    post session_new_url, params: { email: user.email, password: 'password' }
  end
end
