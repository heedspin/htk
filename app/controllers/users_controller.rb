class UsersController < ApplicationController
	skip_before_filter :verify_google_authorization

	def show
		@user = current_user

		@credentials = GoogleAuthorization.load_credentials

	end
end