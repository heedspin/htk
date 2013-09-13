class EmailAccounts::EmailSummariesController < ApplicationController
	def index
		limit = (params[:limit] || 30).to_i
		offset = (params[:offset] || 0).to_i
		page = (params[:page] || 1).to_i
		@email_account = EmailAccount.user(current_user).find(params[:email_account_id])
		@emails = @email_account.emails.uid_desc.limit(limit)
    EmailAccount.attach_to(@emails)
		if page != 1
			@emails = @emails.offset((page.to_i-1) * limit)
		end
		Party.attach_to_emails(@emails)
    respond_to do |format|
      format.html
      format.json { render json: @emails, each_serializer: EmailSummarySerializer, root: 'email_summaries' }
    end
	end
end