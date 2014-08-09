class SigninController < ApplicationController
	skip_before_filter :verify_authenticated_user!

	def signin
		@redirect_url = params[:r]
		if current_user and current_user.google_authorization.try(:authorized?)
			redirect_to @redirect_url || root_url
		else
			@credentials = GoogleAuthorization.load_credentials
		end
	end
end