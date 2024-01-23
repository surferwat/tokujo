Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "main#index"

  # Business Information
  resources :business_informations, only: [:index]
  
  # Dashboard
  # NOTE: the path name "dashboard" is different than the controller name "dashboards".
  namespace :dashboards, as: "dashboard" do
    get "tokujos/:id", to: "tokujos#index", as: "tokujo" # resolves to dashboard_tokujo
    namespace :tokujos do
      scope ":id" do
        get "orders", to: "orders#index", as: "orders" # resolves to dashboard_tokujo_orders
        get "orders/:order_id", to: "orders#show", as: "order" # resolves to dashboard_tokujo_order
        get "patrons", to: "user_patrons#index", as: "user_patrons" # resolves to dashboard_tokujo_user_patrons
        get "patrons/:user_patron_id", to: "user_patrons#show", as: "user_patron" # resolves to dashboard_tokujo_user_patron
      end
    end 
  end
  get "dashboard", to: "dashboards#index", as: "dashboard"

  # Earlies
  resources :earlies, only: [:new, :create]

  # Menu Items
  resources :menu_items

  # Registrations
  get "sign-up", to: "registrations#new", as: "sign_up_new"
  post "sign-up", to: "registrations#create", as: "sign_ups"

  # Sessions
  namespace :sessions do
    get "forgot_password", to: "forgot_passwords#new", as: "forgot_password_new" # resolves to sessions_forgot_password_new
    post "forgot_password", to: "forgot_passwords#create"

    get "reset_password", to: "reset_passwords#edit", as: "reset_password_edit" # resolves to sessions_reset_password_edit
		patch "reset_password", to: "reset_passwords#update", as: "reset_password_update" # resolves to sessions_reset_password_update
  end
  get "sign-in", to: "sessions#new", as: "session_new"
  post "sign-in", to: "sessions#create", as: "sessions"
  delete "logout", to: "sessions#destroy", as: "session"

  # Policies
  get "policies", to: "policies#index"

  # Settings
  namespace :settings do
    get "profiles/edit", to: "profiles#edit", as: "profile_edit" # resolves to settings_profile_edit
    patch "profiles/edit", to: "profiles#update", as: "profiles_update" # resolves to settings_profile_update

    get "passwords/edit", to: "passwords#edit", as: "password_edit" # resolves to settings_password_edit
    patch "passwords/edit", to: "passwords#update", as: "passwords_update" # resolves to settings_passwords_update
  end
  get "settings", to: "settings#index"

  # Accounts
  namespace :accounts do 
    get "plans", to: "plans#index" # resolves to accounts_plans

    get "cards", to: "cards#index"
    namespace :cards do
      get "onboardings", to: "onboardings#index"
      namespace :onboardings do
        get "processed", to: "processed#index" # resolves to accounts_cards_onboardings_processed
        get "dead_link", to: "dead_link#index" # resolves to accounts_cards_onboardings_dead_link
      end
    end

    get "cancellations/new", to: "cancellations#new" # resolves to accounts_new_cancellation
    post "cancellations", to: "cancellations#create" # resolves to accounts_cancellations
  end
  get "accounts", to: "accounts#index"

  # Policies
  get "policies", to: "policies#index"

  # Tokujos
  namespace :tokujos do 
    get "/directory", to: "directory#index", as: "directory" # resolves to tokujos_directory_path
  end
  resources :tokujos

  # Tokujo Sales
  namespace :tokujo_sales do 
    scope ":tokujo_id" do
      get "patrons/new", to: "patrons#new", as: "new_patron" # resolves to tokujo_sales_new_patron
      post "patrons/create", to: "patrons#create", as: "patrons" # resolves to tokujo_sales_patrons
      
      namespace :patrons do
        scope ":patron_id" do
          get "orders/new", to: "orders#new", as: "new_order" # resolves to tokujo_sales_patrons_new_order
          post "orders/create", to: "orders#create", as: "orders" # resolves to tokujo_sales_patrons_orders

          namespace :orders do 
            scope ":id" do
              get "card_setups", to: "card_setups#index", as: "card_setups" # resolves to tokujo_sales_patrons_orders_card_setups
              get "succeeded", to: "succeeded#index", as: "succeeded" # resolves to tokujo_sales_patrons_orders_succeeded
            end
          end
        end
      end
    end
  end
  get "tokujo_sales/:tokujo_id", to: "tokujo_sales#show", as: "tokujo_sale"

  # Tokujo Sale Patrons
  get "tokujo_sale_patrons/new", to: "tokujo_sale_patrons#new", as: "new_tokujo_sale_patron"
  post "tokujo_sale_patrons/create", to: "tokujo_sale_patrons#create", as: "tokujo_sale_patrons"

  # Tokujo Sale Orders
  namespace :tokujo_sale_orders do 
    scope ":id" do
      get "card_setups", to: "card_setups#index", as: "card_setups" # resolves to tokujo_sale_orders_card_setups
      get "card_payments", to: "card_payments#index", as: "card_payments" # resolves to tokujo_sale_orders_card_payments
      get "succeeded", to: "succeeded#index", as: "succeeded" # resolves to tokujo_orders_succeeded
    end
  end
  get "tokujo_sale_orders/new", to: "tokujo_sale_orders#new", as: "new_tokujo_sale_order" # resolves to new_tokujo_sale_order
  post "tokujo_sale_orders/create", to: "tokujo_sale_orders#create", as: "tokujo_sale_orders" # resolves to tokujo_sale_orders

  # Webhooks
  post "webhooks", to: "webhooks#create" # resolves to webhooks
end