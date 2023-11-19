class TokujosController < ApplicationController
  before_action :get_user_tokujos, only: %i[ show edit update ]
  before_action :get_user_menu_item_options, only: %i[ new create ]
  before_action :get_payment_collection_timing_options, only: %i[ new create edit update ]

  def index
    authorize :tokujo, :index?
    
    tokujos = Current.user.tokujos.where(status: "open")

    # Set instance variables for view
    @tokujos = tokujos
  end

  def show
    authorize :tokujo, :show?
    tokujo = @tokujos.find(params[:id])

    # Set instance variables for view
    @tokujo_sales_url = url_for(action: "show", controller: "tokujo_sales", tokujo_id: tokujo.id, only_path: false)
    @tokujo = tokujo
  end

  def new
    authorize :tokujo, :new?
    @tokujo = Tokujo.new
  end

  def create
    authorize :tokujo, :create?
    @tokujo = Current.user.tokujos.new(tokujo_params)
    if @tokujo.save
      redirect_to tokujo_url(@tokujo), notice: "Tokujo was successfully added"
    else
      flash[:alert] = "Tokujo could not be added"
      @tokujo ||= Tokujo.new
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize :tokujo, :edit?
    @tokujo = @tokujos.find(params[:id]) # triggers ActiveRecord::RecordNotFound if no record found
  end

  def update
    authorize :tokujo, :update?
    @tokujo = @tokujos.find(params[:id])

    if @tokujo.update(tokujo_params)
      redirect_to tokujo_url(@tokujo), notice: "Tokujo updated"
    else
      flash[:alert] = "Tokujo could not be updated"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def tokujo_params
    params.require(:tokujo).permit(
      :headline,
      :menu_item_id,
      :payment_collection_timing,
      :ingredients_procurement_time,
      :ingredients_expiration_time,
      :order_period_starts_at,
      :order_period_ends_at,
      :eat_period_starts_at,
      :eat_period_ends_at,
      :number_of_items_available
    )
  end



  def get_user_tokujos
    @tokujos = Current.user.tokujos # where returns [] if no match
  end



  def get_user_menu_item_options
    @menu_item_options = Current.user.menu_items.map { |option| [option.name, option.id] }
  end



  def get_payment_collection_timing_options
    @payment_collection_timing_options = Tokujo.payment_collection_timings.keys.map { |option| [option.humanize, option] }
  end
end
