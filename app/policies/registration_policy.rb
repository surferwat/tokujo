class RegistrationPolicy < ApplicationPolicy
  def new?
    false
  end

  def create?
    false
  end
end