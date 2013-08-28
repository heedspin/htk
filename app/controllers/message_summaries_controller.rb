class MessageSummariesController < ApplicationController
	def index
		limit = (params[:limit] || 30).to_i
		offset = (params[:offset] || 0).to_i
		if (page = (params[:page] || 'top')) == 'top'
			page = 1
		else
			page = page.to_i
		end
		@party = Party.user(current_user).find(params[:party_id])
		@messages = @party.messages.order(:id).limit(limit).includes(:source_email)
		if page != 1
			@messages = @messages.offset((page.to_i-1) * limit)
		end
    respond_to do |format|
      format.html
      format.json { 
      	render json: @messages, each_serializer: MessageSummarySerializer, root: 'message_summaries' 
      }
    end
	end
end