class Accounts::Cards::Onboardings::DeadLinkController < ApplicationController
  def index
    authorize :account, :index?
  end
end
