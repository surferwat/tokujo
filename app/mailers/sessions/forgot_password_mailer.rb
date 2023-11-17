class Sessions::ForgotPasswordMailer < ApplicationMailer
  default from: "ablejo #{ENV["RAILS_CUSTOMER_SUPPORT_EMAIL"]}"
  layout "mailer"

  def forgot_password_email
    @user = params[:user]
    base_url = Rails.env.production? ? ENV["RAILS_DEFAULT_URL_HOST"] : "localhost:3000"
    @url = "#{base_url}/sessions/reset_password?token=#{@user.password_reset_token}"
    mail(to: @user.email, subject: "Reset your password")
  end
end