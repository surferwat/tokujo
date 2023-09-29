class MainController < ApplicationController
  layout "public"

  def index
    authorize :main, :index?
  end
end
