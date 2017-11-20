class RegistrationController < ApplicationController
  def index
  	@error = params[:error]
  end
end
