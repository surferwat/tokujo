require "test_helper"

class TokujosControllerTest < ActionDispatch::IntegrationTest
  setup do 
    @user = users(:user_one)
    @tokujo = tokujos(:tokujo_one)
    @menu_item = menu_items(:menu_item_one)
  end



  # For index
  test "should get index" do
    sign_in(@user)
    get tokujos_url
    assert_response :success
  end



  # For new
  test "should get new" do
    sign_in(@user)
    get new_tokujo_url
    assert_response :success
  end


  
  # For create
  test "should create tokujo where payment_collection_timing value is set to immediate" do
    sign_in(@user)
    
    assert_difference("Tokujo.count") do
      post tokujos_url,
        params: {
          tokujo: {
            headline: "this is a catchy headline",
            payment_collection_timing: "immediate",
            menu_item_id: @menu_item.id
          }
        }
    end

    assert_redirected_to tokujo_url(Tokujo.last)
  end



  test "should create tokujo where payment_collection_timing value is set to delayed" do
    sign_in(@user)
    
    assert_difference("Tokujo.count") do
      post tokujos_url,
        params: {
          tokujo: {
            headline: "this is a catchy headline",
            payment_collection_timing: "delayed",
            ingredients_procurement_time: 3,
            ingredients_expiration_time: 10,
            order_period_starts_at: Time.now, # Needs to be >= to current time, so add 1 day
            order_period_ends_at: Time.now + 5.days,
            eat_period_starts_at: Time.now + 5.days + 4.days,
            eat_period_ends_at: Time.now + 5.days + 3.days + 10.days,
            number_of_items_available: 100,
            menu_item_id: @menu_item.id
          }
        }
    end

    assert_redirected_to tokujo_url(Tokujo.last)
  end



  test "should not create tokujo where payment_collection_timing value is set to delayed and order_period_starts_at is after current beginning of day" do
    sign_in(@user)
    
    assert_no_difference("Tokujo.count") do
      post tokujos_url,
        params: {
          tokujo: {
            headline: "this is a catchy headline",
            payment_collection_timing: "delayed",
            ingredients_procurement_time: 3,
            ingredients_expiration_time: 10,
            order_period_starts_at: Time.now - 1.days, # Needs to be >= to current time, so add 1 day
            order_period_ends_at: Time.now + 5.days,
            eat_period_starts_at: Time.now + 5.days + 4.days,
            eat_period_ends_at: Time.now + 5.days + 3.days + 10.days,
            number_of_items_available: 100,
            menu_item_id: @menu_item.id
          }
        }
    end

    assert_response :unprocessable_entity
  end



  test "should not create tokujo where payment_collection_timing value is set to delayed and order_period_ends_at <= order_period_starts_at" do
    sign_in(@user)
    
    assert_no_difference("Tokujo.count") do
      post tokujos_url,
        params: {
          tokujo: {
            headline: "this is a catchy headline",
            payment_collection_timing: "delayed",
            ingredients_procurement_time: 3,
            ingredients_expiration_time: 10,
            order_period_starts_at: Time.now, # Needs to be >= to current time, so add 1 day
            order_period_ends_at: Time.now,
            eat_period_starts_at: Time.now + 5.days + 4.days,
            eat_period_ends_at: Time.now + 5.days + 3.days + 10.days,
            number_of_items_available: 100,
            menu_item_id: @menu_item.id
          }
        }
    end

    assert_response :unprocessable_entity
  end



  test "should not create tokujo where payment_collection_timing value is set to delayed and eat_period_starts_at <= (order_period_ends_at + ingredients_procurement_time.days)" do
    sign_in(@user)
    
    assert_no_difference("Tokujo.count") do
      post tokujos_url,
        params: {
          tokujo: {
            headline: "this is a catchy headline",
            payment_collection_timing: "delayed",
            ingredients_procurement_time: 3,
            ingredients_expiration_time: 10,
            order_period_starts_at: Time.now, # Needs to be >= to current time, so add 1 day
            order_period_ends_at: Time.now + 5.days,
            eat_period_starts_at: Time.now + 2.days + 4.days,
            eat_period_ends_at: Time.now + 5.days + 3.days + 10.days,
            number_of_items_available: 100,
            menu_item_id: @menu_item.id
          }
        }
    end

    assert_response :unprocessable_entity
  end



  test "should not create tokujo where payment_collection_timing value is set to delayed and eat_period_starts_at <= eat_period_starts_at" do
    sign_in(@user)
    
    assert_no_difference("Tokujo.count") do
      post tokujos_url,
        params: {
          tokujo: {
            headline: "this is a catchy headline",
            payment_collection_timing: "delayed",
            ingredients_procurement_time: 3,
            ingredients_expiration_time: 10,
            order_period_starts_at: Time.now, # Needs to be >= to current time, so add 1 day
            order_period_ends_at: Time.now + 5.days,
            eat_period_starts_at: Time.now + 5.days + 4.days,
            eat_period_ends_at: Time.now + 5.days + 4.days,
            number_of_items_available: 100,
            menu_item_id: @menu_item.id
          }
        }
    end

    assert_response :unprocessable_entity
  end



  test "should not create tokujo where payment_collection_timing value is set to delayed and eat_period_ends_at > (eat_period_starts_at + ingredients_expiration_time.days)" do
    sign_in(@user)
    
    assert_no_difference("Tokujo.count") do
      post tokujos_url,
        params: {
          tokujo: {
            headline: "this is a catchy headline",
            payment_collection_timing: "delayed",
            ingredients_procurement_time: 3,
            ingredients_expiration_time: 10,
            order_period_starts_at: Time.now, # Needs to be >= to current time, so add 1 day
            order_period_ends_at: Time.now + 5.days,
            eat_period_starts_at: Time.now + 5.days + 4.days,
            eat_period_ends_at: Time.now + 5.days + 4.days + 11.days,
            number_of_items_available: 100,
            menu_item_id: @menu_item.id
          }
        }
    end

    assert_response :unprocessable_entity
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