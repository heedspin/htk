class MessageSummariesController < ApplicationController
	def index
		@party = Party.user(current_user).find(params[:party_id])
		@messages = @party.messages.order(:id)
    Email.attach_to(@messages)
    EmailAccount.attach_to(@messages)
    respond_to do |format|
      format.html
      format.json { 
      	render json: @messages, each_serializer: MessageSummarySerializer, root: 'message_summaries' 
      }
    end
	end
end