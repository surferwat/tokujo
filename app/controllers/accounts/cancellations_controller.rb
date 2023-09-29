class Accounts::CancellationsController < ApplicationController
  def new
    authorize :account, :new?
  end

  def create
    authorize :account, :create?

    ActiveRecord::Base.transaction do
      user = Current.user
      cancellation = Cancellation.create!(
        user_id: user.id,
        user_email: user.email,
        user_username: user.username,
        user_created_at: user.created_at,
        user_updated_at: user.updated_at,
        user_stripe_customer_id: user.stripe_customer_id
      )
      user.destroy!
    end
    redirect_to root_path, notice: "Your account has been cancelled"
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotDestroyed
    flash[:alert] = "Failed to cancel your account"
    render :new, status: :unprocessable_entity
  end
end