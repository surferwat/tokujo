class SessionsController < ApplicationController
  layout "public"
  
  def new
    authorize :session, :new?
  end

  def create
    authorize :session, :create?
    user = User.find_by(email: params[:email])
  if user.present? && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to dashboard_path
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    authorize :session, :destroy?
    session[:user_id] = nil
    redirect_to root_path
  end
end
