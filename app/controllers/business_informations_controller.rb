class BusinessInformationsController < ApplicationController
  layout "public"

  def index
    authorize :business_information, :index?

    # Set instances for view
    @team_0_name = ENV["TEAM_0_NAME"]
    @team_0_profile_pic_url = ENV["TEAM_0_PROFILE_PIC_URL"]
    @default_profile_pic_url = ENV["DEFAULT_PROFILE_PIC_URL"]
  end
end
