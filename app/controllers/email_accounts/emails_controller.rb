class EmailAccounts::EmailsController < ApplicationController
	def show
		@email_account = parent_object
	  @email = @email_account.emails.find(params[:id])
	   respond_to do |format|
	     format.html
	     format.json { render json: @email, serializer: EmailSerializer }
	   end
	 end

  def index
		limit = (params[:limit] || 30).to_i
		offset = (params[:offset] || 0).to_i
		page = (params[:page] || 1).to_i
		@email_account = parent_object
		@emails = @email_account.emails.date_desc.limit(limit)
    EmailAccount.attach_to(@emails)
		if page != 1
			@emails = @emails.offset((page.to_i-1) * limit)
		end
	end

	protected

		def parent_object
			@parent_object ||= EmailAccount.user(current_user).find(params[:email_account_id])
		end
end