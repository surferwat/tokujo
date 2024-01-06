require "test_helper"

class MenuItemsControllerTest < ActionDispatch::IntegrationTest
  setup do 
    @user = users(:user_one)
    @menu_item = menu_items(:menu_item_one)
  end


  
  # For index
  test "should get index" do
    sign_in(@user)
    get menu_items_url
    assert_response :success
  end



  test "should get new" do
    sign_in(@user)
    get new_menu_item_url
    assert_response :success
  end



  test "should create menu item" do
    sign_in(@user)

    # Destroy existing records before attempting to create a new one in order to satisfy count limit
    CheckoutSession.destroy_all
    Order.destroy_all
    Tokujo.destroy_all
    MenuItem.destroy_all
    
    assert_difference("MenuItem.count") do
      post menu_items_url,
        params: {
          menu_item: {
            sku: "def123",
            name: "Test Menu Item",
            description: "This is a new menu item",
            max_ingredient_storage_life: 1,
            max_ingredient_delivery_time: 1,
            currency: "USD",
            price: 10000,
            image_one: fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', 'test_image.jpeg'), 'image/jpeg')
          }
        }
    end

    assert_redirected_to menu_item_url(MenuItem.last)
  end



  test "should show menu item" do
    sign_in(@user)
    get menu_item_path(@menu_item)
    assert_response :success
  end



  test "should get edit" do
    sign_in(@user)
    get edit_menu_item_url(@menu_item)
    assert_response :success
  end



  test "should update menu item" do
    sign_in(@user)
    put "/menu_items/#{@menu_item.id}", params: { menu_item: { sku: "newsku" } }
    assert_redirected_to menu_item_url(@menu_item)
    @menu_item.reload
    assert_equal "newsku", @menu_item.sku
  end



  private



  def sign_in(user)
    post session_new_url, params: { email: user.email, password: 'password' }
  end
end
