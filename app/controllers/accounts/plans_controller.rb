class Accounts::PlansController < ApplicationController
  def index
    authorize :account, :index?
  end
end