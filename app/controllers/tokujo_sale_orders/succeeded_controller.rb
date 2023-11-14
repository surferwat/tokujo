class TokujoSaleOrders::SucceededController < ApplicationController
  include CheckoutSessionExistable
  layout "public_for_patrons"
  
  def index
    authorize :tokujo_sale_order, :index?
  end
end
