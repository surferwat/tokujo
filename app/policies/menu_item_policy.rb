class MenuItemPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.present?
        scope.where(user_id: user.id)
      else
        scope.none
      end
    end
  end



  def index?
    user.present?
  end



  def show?
    user.present?
  end



  def new?
    user.present?
  end



  def create?
    user.present?
  end



  def edit?
    user.present?
  end



  def update?
    user.present?
  end
end
