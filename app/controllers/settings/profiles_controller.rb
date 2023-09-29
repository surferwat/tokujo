class Settings::ProfilesController < ApplicationController
  # Displays the form for editing the user's profile
  def edit
    authorize :setting, :edit?
  end

  # Updates the user's profile based on the submitted form data
  def update
    authorize :setting, :update?

    if Current.user.update(user_params)
      redirect_to settings_profile_edit_path, notice: "Profile updated"
    else
      flash[:alert] = "Profile could not be updated"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # Strong parameters for user profile updates
  def user_params
    params.require(:user).permit(
      :username,
    )
  end
end
