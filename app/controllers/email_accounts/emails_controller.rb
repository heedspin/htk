class EmailAccounts::EmailsController < ApplicationController
	def index
		@email_account = parent_object
		@emails = @email_account.fetch_emails(:limit => 30)
    respond_to do |format|
      format.html
      format.json { render json: @emails }
    end
	end

	def show
	  @email_account = parent_object
	  @email = @email_account.fetch_email(:uid => params[:id])
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