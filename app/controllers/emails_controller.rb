class EmailsController < ApplicationController
	def show
	  @email = current_user.emails.find(params[:id])
	   respond_to do |format|
	     format.html
	     format.json { render json: @email, serializer: EmailSerializer }
	   end
	 end

  def index
		limit = (params[:limit] || 30).to_i
		offset = (params[:offset] || 0).to_i
		page = (params[:page] || 1).to_i
		@emails = current_user.emails.not_deleted.date_desc.limit(limit)
		if page != 1
			@emails = @emails.offset((page.to_i-1) * limit)
		end
	end
end