module CheckoutSessionExistable
  extend ActiveSupport::Concern

  included do
    before_action :check_checkout_session_existence
  end

  private

  def check_checkout_session_existence
    checkout_session = CheckoutSession.find_by(id: params[:checkout_session_id])
    if checkout_session == nil || checkout_session.deleted_at.present?
      redirect_to tokujo_sale_path(params[:tokujo_id])
      return
    end

    # Set instance variables for action
    @checkout_session = checkout_session
  end
end