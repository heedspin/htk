class EmailAccounts::EmailsController < ApplicationController
	def show
	  @email = Email.user(current_user).find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @email, serializer: EmailSerializer }
    end
  end
end