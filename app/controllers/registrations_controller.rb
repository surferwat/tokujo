class RegistrationsController < ApplicationController
  include RegistrationsHelper
  layout "public"

   def new
    authorize :registration, :new?
    @user = User.new
  end
  
  def create
    authorize :registration, :create?
    @user = User.new(user_params)
    @user.stripe_customer_id = StripeService::CreateCustomer.new.call
    if @user.save
      session[:user_id] = @user.id
      redirect_to tokujos_path, notice: "Successfully created account"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email, 
      :password, 
      :password_confirmation
    )
  end
end
