class MenuItemsController < ApplicationController
  before_action :get_menu_items, only: [ :index, :show, :create, :edit, :update ]
  before_action :get_currency_options, only: [ :new, :edit ]


  
  def index
    authorize :menu_item, :index?

    # Set instance variables for view
    @keys = MenuItem.column_names
    @menu_items = MenuItem.where(user_id: Current.user.id)
  end



  def show
    authorize :menu_item, :show?

    # Set instanve variables
    @menu_item = @menu_items.find(params[:id])
    @image_url = @menu_item.image_one.attached? ? rails_blob_path(@menu_item.image_one.variant(resize_and_pad: [300, 300], format: :png, saver: { subsample_mode: "on", strip: true, interlace: true, quality: 50 }), only_path: true) : nil
  end



  def new
    authorize :menu_item, :new?
    
    @menu_item = MenuItem.new
  end



  def create
    authorize :menu_item, :create?

    raise ArgumentError, "Currency cannot be nil" if menu_item_params[:currency].nil?

    # Convert :price to internal representation
    price_base = Monetize.parse(menu_item_params[:price], menu_item_params[:currency])
    price_base = price_base.cents if menu_item_params[:currency].upcase == "USD"
    menu_item_params[:price_base] = price_base
		menu_item_params.delete(:price)

    # Create new MenuItem instance
    @menu_item = @menu_items.new(menu_item_params)

    # Attach image to MenuItem instance
    if params[:menu_item][:image_one].present? && @menu_item.valid?
      begin
        @menu_item.image_one.attach(params[:menu_item][:image_one])
      rescue StandardError => e
        # Set errors
        @menu_item.errors.add(:image_one, "Failed to upload image: #{e}")
        
        # Set instannce variables for view
        get_currency_options
        
        # Render view
        render :new, status: :unprocessable_entity and return
      end
    end

    # Save MenuItem instance
    if @menu_item.save
      redirect_to menu_item_path(@menu_item), notice: "Successfully added menu item"
    else
      # Set instannce variables for view
      get_currency_options
      
      # Render view
      render :new, status: :unprocessable_entity
    end
  end



  def edit
    authorize :menu_item, :edit?

    menu_item = @menu_items.find(params[:id])

    # Set instance variables for view
    set_instance_variables(
      menu_item: menu_item,
      currency: menu_item.currency
    )
  end



  def update
    authorize :menu_item, :update?

    menu_item = @menu_items.find(params[:id])
    
    if menu_item.update(menu_item_params)
      redirect_to menu_item_path(menu_item), notice: "Successfully updated menu item"
    else
      # Set instance variables for view
      set_instance_variables(
        menu_item: menu_item,
        currency: menu_item.currency
      )

      # Render view
      render :edit, status: :unprocessable_entity
    end
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
      :currency,
      :image_one,
    )
  end



  def get_menu_items
    @menu_items = Current.user.menu_items
  end



  def get_currency_options
    @currency_options = CurrencyType::VALUES.map { |name, value| [name.to_s, name.to_s] }
  end
end

