class TokujoSalePatronsController < ApplicationController
  include CheckoutSessionExistable
  layout "public_for_patrons"



  def new    
    authorize :tokujo_sale_patron, :new?

    tokujo_id = params[:tokujo_id]
    size = params[:size]
    size_i = size.to_i
    checkout_session = @checkout_session

    tokujo = Tokujo.find(tokujo_id)
    
    payment_collection_timing = tokujo.payment_collection_timing
    case payment_collection_timing
    when "immediate"
    when "delayed"
      # Check whether order size is possible
      is_valid, max_allowed = is_valid_order_size(size_i, tokujo.number_of_items_taken, tokujo.number_of_items_available)
     
      if !is_valid
        redirect_to tokujo_sale_path(tokujo.id), alert: "Number of orders selected should be less than #{max_allowed}"
      end
    end

    # Set instance variables for views
    @checkout_session_id = checkout_session.id
    @user_patron = UserPatron.new
    @tokujo = tokujo
    @size = size
    @total_price_with_tax = (size_i * tokujo.menu_item.price_with_tax_cents).to_f
  end

  
  
  def create
    authorize :tokujo_sale_patron, :create?

    tokujo_id = params[:tokujo_id]
    size = params[:size]
    total_price_with_tax = params[:total_price_with_tax]
    email = params[:user_patron][:email]
    checkout_session = @checkout_session

    tokujo = Tokujo.find(tokujo_id)

    # Set patron for this checkout session
    user_patron = nil
    begin
      user_patron = UserPatron.find_by(email: email)

      case true
      # Case 1
      # First time that patron is providing email address during this checkout session. 
      # Email address provided does not exist in db.
      when checkout_session.user_patron_id.nil? && user_patron.nil?
        ActiveRecord::Base.transaction do
          user_patron = create_user_patron(email)
          update_checkout_session_with_patron_id(checkout_session, user_patron.id)
        end
      # Case 2
      # First time that patron is providing email address during this checkout session. 
      # Email address provided does exist in db.
      when checkout_session.user_patron_id.nil? && !user_patron.nil?
        update_checkout_session_with_patron_id(checkout_session, user_patron.id)
      # Case 3
      # Not first time that patron is providing email address during this checkout session. 
      # Email address provided does not exist in db.
      when !checkout_session.user_patron_id.nil? && user_patron.nil?
        ActiveRecord::Base.transaction do
          user_patron = create_user_patron(email)
          update_checkout_session_with_patron_id(checkout_session, user_patron.id)

          if !checkout_session.order_id.nil?
            order = Order.find(checkout_session.order_id)
            order.user_patron_id = user_patron.id
            order.save!
          end
        end
      # Case 4
      # Not first time that patron is providing email address during this checkout session. 
      # Email address provided does exist in db.
      when !checkout_session.user_patron_id.nil? && !user_patron.nil?
        if checkout_session.user_patron_id != user_patron.id
          ActiveRecord::Base.transaction do
            update_checkout_session_with_patron_id(checkout_session, user_patron.id)
            if !checkout_session.order_id.nil?
              order = Order.find(checkout_session.order_id)
              order.user_patron_id = user_patron.id
              order.save!
            end
          end
        end
      end
    rescue StandardError => e
      # Set instance variables for views
      @checkout_session_id =  checkout_session.id
      @user_patron = UserPatron.new
      @tokujo = tokujo
      @size = size
      @total_price_with_tax = (@size.to_i * @tokujo.menu_item.price_with_tax_cents).to_f
      @user_patron = UserPatron.new
      render :new, status: :unprocessable_entity
      return
    end
    redirect_to new_tokujo_sale_order_path(tokujo_id: tokujo.id, patron_id: user_patron.id, checkout_session_id: checkout_session.id, size: size, total_price_with_tax: total_price_with_tax)
  end



  private
  

  
  def is_valid_order_size(size, curr_aggr_placed_size, max_aggr_size)
    new_curr_aggr_placed_size = new_curr_aggr_placed_size(size, curr_aggr_placed_size)
    max_allowed = max_aggr_size - curr_aggr_placed_size
    [new_curr_aggr_placed_size <= max_aggr_size, max_allowed]
  end



  def create_user_patron(email)
    user_patron = UserPatron.new(email: email)
    user_patron.stripe_customer_id = StripeApiCaller::Customer.new.create_customer.id
    user_patron.save!
    user_patron
  end



  def update_checkout_session_with_patron_id(checkout_session, user_patron_id)
    checkout_session.user_patron_id = user_patron_id
    checkout_session.save!
  end
end
