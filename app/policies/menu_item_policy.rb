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
end
