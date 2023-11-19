class Tokujos::DirectoryController < ApplicationController
  def index
    authorize :tokujo, :index?

    # Set instance variables for view
    @keys = Tokujo.column_names
    @tokujos = Tokujo.where(user_id: Current.user.id)
  end
end