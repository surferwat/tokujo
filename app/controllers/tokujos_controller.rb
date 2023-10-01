class TokujosController < ApplicationController
  before_action :get_user_tokujos, only: %i[ index show edit update ]
  before_action :get_user_menu_item_options, only: %i[ new edit ]
  before_action :get_payment_collection_timing_options, only: %i[ new edit ]

  def index
    authorize :tokujo, :index?
  end

  def show
    authorize :tokujo, :show?
    @tokujo = @tokujos.find(params[:id])
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
      :menu_item_id,
      :payment_collection_timing,
      :number_of_items_available,
      :ends_at,
    )
  end



  def get_user_tokujos
    @tokujos = Current.user.tokujos.where(status: "open") # where returns [] if no match
  end



  def get_user_menu_item_options
    @menu_item_options = Current.user.menu_items.map { |option| [option.name, option.id] }
  end



  def get_payment_collection_timing_options
    @payment_collection_timing_options = Tokujo.payment_collection_timings.keys.map { |option| [option.humanize, option] }
  end
end
