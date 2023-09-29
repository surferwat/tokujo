require "test_helper"

class TokujosControllerTest < ActionDispatch::IntegrationTest
  setup do 
    @user = users(:user_one)
    @tokujo = tokujos(:tokujo_one)
    @menu_item = menu_items(:menu_item_one)
  end

  test "should get index" do
    sign_in(@user)
    get tokujos_url
    assert_response :success
  end

  test "should get new" do
    sign_in(@user)
    get new_tokujo_url
    assert_response :success
  end

  test "should create tokujo" do
    sign_in(@user)
    
    assert_difference("Tokujo.count") do
      post tokujos_url,
        params: {
          tokujo: {
            ends_at: Time.now,
            number_of_items_available: 100,
            menu_item_id: @menu_item.id
          }
        }
    end

    assert_redirected_to tokujo_url(Tokujo.last)
  end

  test "should show tokujo" do
    sign_in(@user)
    get tokujo_path(@tokujo)
    assert_response :success
  end

  test "should get edit" do
    sign_in(@user)
    get edit_tokujo_url(@tokujo)
    assert_response :success
  end

  test "should update tokujo" do
    sign_in(@user)
    put tokujo_url(@tokujo), params: { tokujo: { number_of_items_available: 101 } }
    assert_redirected_to tokujo_url(@tokujo)
    @tokujo.reload
    assert_equal 101, @tokujo.number_of_items_available
  end

  test "should not update tokujo status" do
    sign_in(@user)
    put tokujo_url(@tokujo), params: { tokujo: { status: 1 } }
    assert_redirected_to tokujo_url(@tokujo)
    @tokujo.reload
    assert_not_equal 1, @tokujo.status
  end

  private 
  
  def sign_in(user)
    post session_new_url, params: { email: user.email, password: 'password' }
  end
end
