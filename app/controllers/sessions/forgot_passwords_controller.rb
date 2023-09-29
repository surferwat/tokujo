class Sessions::ForgotPasswordsController < ApplicationController
  layout "public"

  def new
    authorize :session, :new?
    @user = User.new
  end

  def create
    authorize :session, :create?
    
    user = User.find_by(email: params[:user][:email])

    if user
      user.reset_password
      Sessions::ForgotPasswordMailer.with(user: user).forgot_password_email.deliver_now
      redirect_to root_path, notice: "Check your email for reset instructions"
    else
      render :new, status: :unprocessable_entity
    end
  end
end
