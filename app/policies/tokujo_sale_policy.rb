class TokujoSalePolicy < ApplicationPolicy
  def index?
    true
  end

  def new?
    true
  end
  
  def show?
    true
  end

  def create?
    true
  end
end
