class TokujoSaleOrders::SucceededController < ApplicationController
  layout "public_for_patrons"
  before_action :check_checkout_session_existence
  
  def index
    authorize :tokujo_sale_order, :index?
  end

  

  private



  def check_checkout_session_existence
    checkout_session = CheckoutSession.find_by(id: params[:checkout_session_id])
    if checkout_session.nil?
      redirect_to tokujo_sale_path(params[:tokujo_id])
    elsif checkout_session.deleted_at.present?
      redirect_to tokujo_sale_path(params[:tokujo_id]) unless Time.now - checkout_session.deleted_at < 1.minute # addresses case where checkout_session object is deleted before view is rendered
    end
  end
end