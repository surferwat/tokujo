class PoliciesController < ApplicationController
  layout "public"
    
  def index
    authorize :policy, :index?
  end
end