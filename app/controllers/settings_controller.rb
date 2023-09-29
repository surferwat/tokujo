class SettingsController < ApplicationController
  def index
    authorize :setting, :index?
  end
end