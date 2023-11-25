class Dashboards::Tokujos::UserPatronsController < ApplicationController
  def index
    authorize :dashboard, :index?

    tokujo = Tokujo.find(params[:id])

    # Set instance variables for view
    @user_patrons = UserPatron.joins(orders: :user_patron).where(user_patrons: { id: tokujo.orders.pluck(:id) })
    @keys = UserPatron.column_names
  end



  def show
    authorize :dashboard, :show?

    user_patron = UserPatron.find(params[:user_patron_id])

    # Set instance variables for new
    @user_patron = user_patron
  end
end