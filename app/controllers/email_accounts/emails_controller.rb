class EmailAccounts::EmailsController < ApplicationController
	def index
		@email_account = parent_object
		limit = (params[:limit] || 30).to_i
		offset = (params[:offset] || 0).to_i
		if (page = (params[:page] || 'top')) == 'top'
			page = 1
		else
			page = page.to_i
		end
		@emails = @email_account.emails.uid_desc.limit(limit)
		if page != 1
			@emails = @emails.offset((page.to_i-1) * limit)
		end
    respond_to do |format|
      format.html
      format.json { render json: @emails }
    end
	end

	def show
	  @email_account = parent_object
	  @email = @email_account.emails.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @email }
    end
  end

	protected

		def parent_object
			@parent_object ||= EmailAccount.user(current_user).find(params[:email_account_id])
		end
end