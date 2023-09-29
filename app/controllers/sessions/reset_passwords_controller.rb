class Sessions::ResetPasswordsController < ApplicationController
  layout "public"

  def edit
    authorize :session, :edit?
    @token = params[:token]
  end

  def update
    authorize :session, :update?
    
    token = params[:token]
    user = User.find_by(password_reset_token: token)
  
    if user&.valid_reset_token?
      if user.update(password_reset_params)
        redirect_to root_path, notice: "Password successfully reset"
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to sessions_forgot_password_path, status: :unprocessable_entity, alert: "Invalid request"
    end
  end

  private

  def password_reset_params 
    params.permit(
      :password,
      :password_confirmation
    )
  end
end