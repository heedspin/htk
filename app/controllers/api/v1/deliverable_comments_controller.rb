class Api::V1::DeliverableCommentsController < Api::V1::ApiController
	respond_to :json
	def default_serializer_options
	  {root: 'comment'}
	end

  def create
  	@deliverable = editable_parent_object
  	@comment = @deliverable.comments.build(comment_type_id: params[:comment_type_id], note: params[:note], comment_type_id: params[:comment_type_id])
  	@comment.creator = current_user 
  	if @comment.save
			render json: { 
				comment: DeliverableCommentSerializer.new(@comment, root: false),
				deliverable: DeliverableSerializer.new(@comment.deliverable, root: false)
			}
		else
			render json: { errors: @comment.errors }, status: 422
		end
	end

	protected

		def editable_parent_object
			@parent_object ||= Deliverable.editable_by(current_user).find(params[:deliverable_id])
		end

		# def current_object
		# 	@current_object ||= parent_object.
		# end

end