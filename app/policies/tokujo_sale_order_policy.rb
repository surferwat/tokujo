class TokujoSaleOrderPolicy < ApplicationPolicy
  def index?
    true
  end

  def new?
    true
  end
  
  def create?
    true
  end
end
