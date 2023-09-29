class Settings::PasswordsController < ApplicationController
  def edit
    authorize :setting, :edit?
  end

  def update
    authorize :setting, :update?
    
    if Current.user.update(password_params)
      redirect_to settings_profile_edit_path, notice: "Password updated"
    else 
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(
      :password, 
      :password_confirmation
    )
  end
end
