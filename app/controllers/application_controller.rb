require "./lib/current.rb"

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :set_current_user

  def set_current_user
    Current.user = current_user
  end



  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end



  def new_curr_aggr_placed_size(size, curr_aggr_placed_size)
    curr_aggr_placed_size != 0 ? curr_aggr_placed_size + size : size
  end



  def set_instance_variables(variables)
    variables.each do |name, value|
      instance_variable_set("@#{name}", value)
    end
  end
end
