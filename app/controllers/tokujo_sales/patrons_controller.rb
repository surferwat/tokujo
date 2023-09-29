class TokujoSales::PatronsController < ApplicationController
  layout "public_for_patrons"

  def new
    authorize :tokujo_sale, :new?
    
    tokujo_id = params[:tokujo_id]
    size = params[:size]
    size_i = size.to_i

    # Check if checkout session exists
    checkout_session = CheckoutSession.find_by(id: params[:checkout_session_id])
    if checkout_session == nil
      redirect_to tokujo_sale_path(tokujo_id)
      return
    end

    # Check whether order size is possible
    tokujo = Tokujo.find(tokujo_id)
    curr_aggr_placed_size = tokujo.number_of_items_taken
    max_aggr_size = tokujo.number_of_items_available
    validate_order_size(size_i, curr_aggr_placed_size, max_aggr_size)

    # If the number of orders placed by the patron results in the
    # number_of_items_taken == number_of_items_available, then
    # we need to close this tokujo instance.
    is_at_max_aggr_size = check_max_aggr_size(size_i, tokujo.number_of_items_taken, tokujo.number_of_items_available)
    if is_at_max_aggr_size
      tokujo.status = "closed"
      tokujo.save
    end

    # Set instance variables for views
    @checkout_session_id = checkout_session.id
    @user_patron = UserPatron.new
    @tokujo = tokujo
    @size = size
    @total_price_with_tax = (size_i * tokujo.menu_item.price_with_tax_cents).to_f
  end



  def create
    authorize :tokujo_sale, :create?

    tokujo_id = params[:tokujo_id]

    # Check if checkout session exists
    checkout_session = CheckoutSession.find_by(id: params[:checkout_session_id])

    if checkout_session == nil
      redirect_to tokujo_sale_path(tokujo_id)
      return
    end

    tokujo = Tokujo.find(tokujo_id)

    # Set user_patron instance
    email = params[:user_patron][:email]
    user_patron = UserPatron.find_by(email: email)
    if user_patron == nil
      user_patron = UserPatron.new(email: email)
      user_patron.stripe_customer_id = StripeApiCaller::Customer.new.create_customer.id

      begin
        ActiveRecord::Base.transaction do
          if user_patron.save!
            # Handle where patron comes to this page from another page ahead in the 
            # checkout session process and decides to provide a different email address.
            if checkout_session.user_patron_id != user_patron.id
              checkout_session.user_patron_id = user_patron.id
              checkout_session.save!
              if checkout_session.order_id != nil
                order = Order.find(checkout_session.order_id)
                order.user_patron_id = user_patron.id
                order.save!
              end
            end
          end
        end
      rescue StandardError => e
        # Set instance variables for views
        @checkout_session_id = checkout_session.id
        @user_patron = UserPatron.new
        @tokujo = tokujo
        @size = params[:size]
        @total_price_with_tax = (@size.to_i * @tokujo.menu_item.price_with_tax_cents).to_f
        @user_patron = UserPatron.new
        render :new, status: :unprocessable_entity
        return
      end
    end
    redirect_to tokujo_sales_patrons_new_order_path(tokujo_id: tokujo.id, patron_id: user_patron.id, checkout_session_id: params[:checkout_session_id], size: params[:size], total_price_with_tax: params[:total_price_with_tax])
    return
    
  rescue ActiveRecord::RecordInvalid
    @checkout_session_id = checkout_session.id
    @order = Order.new
    @tokujo = tokujo
    @size = size
    @total_price_with_tax = (@size.to_i * @tokujo.menu_item.price_with_tax_cents).to_f
    @user_patron = UserPatron.new
    render :new, status: :unprocessable_entity
  end



  private
  
  def validate_order_size(size, curr_aggr_placed_size, max_aggr_size)
    new_curr_aggr_placed_size = new_curr_aggr_placed_size(size, curr_aggr_placed_size)
    max_allowed = max_aggr_size - curr_aggr_placed_size
    if new_curr_aggr_placed_size > max_aggr_size
      redirect_to tokujo_sale_path(tokujo.id), alert: "Number of orders selected should be less than #{max_allowed}"
    end
  end


  
  def check_max_aggr_size(size, curr_aggr_placed_size, max_aggr_size)
    new_aggr_size = new_curr_aggr_placed_size(size, curr_aggr_placed_size)
    new_aggr_size == max_aggr_size
  end
end
