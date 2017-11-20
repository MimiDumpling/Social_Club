class LogoutController < ApplicationController
	def show
		reset_session
		redirect_to "/"
	end

end
