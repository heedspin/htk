class Api::V1::ThreadDeliverablesController < Api::V1::ApiController
	respond_to :json

  def create
  	@deliverable = Deliverable.editable_by(current_user).find(params[:deliverable_id])
  	@message_thread = MessageThread.accessible_to(current_user).find(params[:message_thread_id])
  	@thread_deliverable = ThreadDeliverable.new(message_thread_id: @message_thread.id, deliverable_id: @deliverable.id)
  	if @thread_deliverable.save
  		render json: { result: 'success' }
  	else
			render json: { errors: @thread_deliverable.errors }, status: 422
  	end
	end

	def destroy
  	@deliverable = Deliverable.editable_by(current_user).find(params[:deliverable_id])
  	@message_thread = MessageThread.accessible_to(current_user).find(params[:message_thread_id])
  	@thread_deliverable = ThreadDeliverable.where({ message_thread_id: @message_thread.id, deliverable_id: @deliverable.id }).first
  	if @thread_deliverable.destroy
  		render json: { result: 'success' }
  	else
			render json: { errors: @thread_deliverable.errors }, status: 422
  	end
	end

end