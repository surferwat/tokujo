require "test_helper"

class MenuItemTest < ActiveSupport::TestCase
  def setup 
    @menu_item = menu_items(:menu_item_one)
  end

  # Enums
  test "currency enum values should be set correctly" do
    menu_item = MenuItem.new

    assert_equal "USD", menu_item.currency
    menu_item.currency = "JPY"
    assert_equal "JPY", menu_item.currency
  end



  # Validations
  test "should be valid" do 
    assert @menu_item.valid?
  end



  test "name should be present" do 
    @menu_item.name = ""
    assert_not @menu_item.valid?
  end



  test "max_ingredient_storage_life should be present and greater than 0" do
    @menu_item.max_ingredient_storage_life = nil
    assert_not @menu_item.valid?

    @menu_item.max_ingredient_storage_life = 0
    assert_not @menu_item.valid?

    @menu_item.max_ingredient_storage_life = -1
    assert_not @menu_item.valid?

    @menu_item.max_ingredient_storage_life = 9.99
    assert @menu_item.valid?
  end



  test "max_ingredient_delivery_time should be present and greater than 0" do
    @menu_item.max_ingredient_delivery_time = nil
    assert_not @menu_item.valid?

    @menu_item.max_ingredient_delivery_time = 0
    assert_not @menu_item.valid?

    @menu_item.max_ingredient_delivery_time = -1
    assert_not @menu_item.valid?

    @menu_item.max_ingredient_delivery_time = 9.99
    assert @menu_item.valid?
  end



  test "currency should be present" do 
    @menu_item.currency = ""
    assert_not @menu_item.valid?
  end



  test "user can create up to 1 item" do
    user = users(:user_one)
    user.menu_items.create( 
      sku: "test1",
      name: "Test Menu Item 1",
      description: "This is a new menu item 1",
      max_ingredient_storage_life: 1,
      max_ingredient_delivery_time: 1,
      currency: "JPY",
      price: 1000,
    )
    menu_item_2 = user.menu_items.create(
      sku: "test2",
      name: "Test Menu Item 2",
      description: "This is a new menu item 2",
      max_ingredient_storage_life: 1,
      max_ingredient_delivery_time: 1,
      currency: "JPY",
      price: 1000,
    )
    
    refute menu_item_2.valid?
    assert_includes menu_item_2.errors[:base], "You can only create up to 1 item"
  end
  
  # Callbacks
  test "should update menu item price with tax when price is changed" do
    @menu_item.price_base = 1000
    @menu_item.save
    expected_price_with_tax = 1000 * 1.08
    assert_equal expected_price_with_tax, @menu_item.price_with_tax_base
  end



  # Associations
  test "should belong to user" do
    assert_respond_to @menu_item, :user
  end



  test "should have one attached image" do
    assert_respond_to @menu_item, :image_one
  end
end
