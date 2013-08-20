class EmailAccounts::EmailSummariesController < ApplicationController
	def index
		limit = (params[:limit] || 30).to_i
		offset = (params[:offset] || 0).to_i
		if (page = (params[:page] || 'top')) == 'top'
			page = 1
		else
			page = page.to_i
		end
		@email_account = EmailAccount.user(current_user).find(params[:email_account_id])
		@emails = @email_account.emails.uid_desc.limit(limit)
		if page != 1
			@emails = @emails.offset((page.to_i-1) * limit)
		end
    respond_to do |format|
      format.html
      format.json { render json: @emails, each_serializer: EmailSummarySerializer, root: 'email_summaries' }
    end
	end
end