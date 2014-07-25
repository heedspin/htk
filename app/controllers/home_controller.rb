class HomeController < ApplicationController
	skip_before_filter :authenticate_user!, :only => :index
	def index
		if current_user
			redirect_to current_user.preferences.home_page_url
		end
	end
end
