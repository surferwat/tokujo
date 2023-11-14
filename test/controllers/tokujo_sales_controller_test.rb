require "test_helper"

class TokujoSalesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tokujo_delayed = tokujos(:tokujo_one)
    @tokujo_immediate = tokujos(:tokujo_two)
  end

  test "should get show" do
    get tokujo_sale_url(tokujo_id: @tokujo_delayed.id)
    assert_response :success
  end

  test "should create checkout session" do
    assert_difference("CheckoutSession.count") do
      get tokujo_sale_url(tokujo_id: @tokujo_delayed.id)
    end
  end

  test "should render show_for_delayed" do
    get tokujo_sale_url(tokujo_id: @tokujo_delayed)
    assert_template :show_for_delayed
  end

  test "should render show_for_immediate" do
    get tokujo_sale_url(tokujo_id: @tokujo_immediate)
    assert_template :show_for_immediate
  end

  test "should reopen tokujo if closed because of order that did not complete process" do
    user = users(:user_one)
    menu_item = menu_items(:menu_item_one)
    estimated_minutes_to_input_card_info = 2 * 60
    initial_number_of_items_taken = 100
    size_of_order = 8
    
    # Create tokujo
    tokujo = Tokujo.create(
      headline: "tokujo sales controller headline",
      payment_collection_timing: "delayed",
      ingredients_procurement_time: 3,
      ingredients_expiration_time: 10,
      order_period_starts_at: Time.now, # Needs to be >= to current time, so add 1 day
      order_period_ends_at: Time.now + 5.days,
      eat_period_starts_at: Time.now + 5.days + 4.days,
      eat_period_ends_at: Time.now + 5.days + 4.days + 9.days,
      number_of_items_available: 100,
      menu_item_id: menu_item.id,
      user_id: user.id
    )

    # Create user patron
    user_patron = user_patrons(:user_patron_one)

    # Create dirty order
    order = Order.create(
      size: 8,
      payment_amount: 10000,
      tokujo_id: tokujo.id,
      user_patron_id: user_patron.id
    )
    order.created_at -= 2.minutes
    order.save

    time_difference_in_minutes = (Time.current - order.created_at)

    # Update tokujo
    tokujo.status = "closed"
    tokujo.number_of_items_taken = initial_number_of_items_taken
    tokujo.save

    number_of_completed_orders = tokujo.orders.where(status: "open", item_status: "payment_due").sum(:size)

    # Create checkout session
    checkout_session = CheckoutSession.create(user_patron_id: user_patron.id, order_id: order.id)

    # Assert 
    assert_equal "closed", tokujo.status
    assert_equal tokujo.number_of_items_taken, tokujo.number_of_items_available
    assert number_of_completed_orders < tokujo.number_of_items_available

    # Get tokujo_sales_path
    get tokujo_sale_url(tokujo_id: tokujo.id)
    
    tokujo.reload

    # Assert 
    assert_equal "open", tokujo.status
    assert_equal initial_number_of_items_taken - size_of_order, tokujo.number_of_items_taken
    assert_raises(ActiveRecord::RecordNotFound) do
      Order.find(order.id)
    end
    assert_raises(ActiveRecord::RecordNotFound) do
      CheckoutSession.find(checkout_session.id)
    end
  end
end