class Settings::MyMenuItemsController < ApplicationController
  before_action :get_menu_items, only: [ :index, :show, :create, :edit, :update ]
  


  def index
    authorize :setting, :index?
    @keys = MenuItem.column_names
    @menu_items = @menu_items.all
  end



  def new
    authorize :setting, :new?
    @menu_item = MenuItem.new
  end



  def show
    authorize :setting, :show?
    @menu_item = @menu_items.find(params[:id])
  end



  def create
    authorize :setting, :create?

    # Convert :price to internal representation
    price_base = Monetize.parse(menu_item_params[:price], menu_item_params[:price_currency])
    price_base = price_base.cents if menu_item_params[:price_currency].downcase == "usd"
    menu_item_params[:price_base] = price_base
		menu_item_params.delete(:price)

    # Create new MenuItem instance
    @menu_item = @menu_items.new(menu_item_params)

    # Attach image to MenuItem instance
    if params[:menu_item][:image_one].present? && @menu_item.valid?
      begin
        @menu_item.image_one.attach(params[:menu_item][:image_one])
      rescue StandardError => e
        @menu_item.errors.add(:image_one, "Failed to upload image: #{e}")
        render :new, status: :unprocessable_entity and return
      end
    end

    # Save MenuItem instance
    if @menu_item.save
      redirect_to settings_my_menu_item_path(@menu_item), notice: "Successfully added menu item"
    else
      render :new, status: :unprocessable_entity
    end
  end



  def edit
    authorize :setting, :edit?
    @menu_item = @menu_items.find(params[:id])
  end



  def update
    authorize :setting, :update?
    @menu_item = @menu_items.find(params[:id])
    if @menu_item.update(menu_item_params)
      redirect_to settings_my_menu_item_path(@menu_item), notice: "Successfully updated menu item"
    else
      render :edit, status: :unprocessable_entity
    end
  end



  def destroy
  end



  private



  def menu_item_params
    params.require(:menu_item).permit(
      :sku,
      :name, 
      :description,
      :max_ingredient_storage_life,
      :max_ingredient_delivery_time,
      :price,
      :price_currency,
      :image_one,
    )
  end


  
  def get_menu_items
    @menu_items = Current.user.menu_items
  end
end
