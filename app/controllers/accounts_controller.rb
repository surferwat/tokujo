class AccountsController < ApplicationController
  def index
    authorize :account, :index?
  end
end
