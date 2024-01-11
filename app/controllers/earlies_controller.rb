class EarliesController < ApplicationController
  def new 
    authorize :early, :new?
    
    # Set instance variable for view
    set_instance_variables(early: Early.new)
  end

  def create
    authorize :early, :create?
    early = Early.new(early_params)
    if early.save
      render :show
    else
      @early ||= early
      render :new, status: :unprocessable_entity
    end
  end

  def show
    authorize :early, :show?
  end



  private



  def early_params
    params.require(:early).permit(
      :email
    )
  end
end
