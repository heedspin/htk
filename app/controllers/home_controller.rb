class HomeController < ApplicationController
  def index
  	if current_user
  		if current_user.email_accounts.count == 1
	  		redirect_to email_account_url(current_user.email_accounts.first)
	  	else
	  		redirect_to email_accounts_url
	  	end
  	end
  end
end
