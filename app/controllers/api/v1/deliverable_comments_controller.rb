class Api::V1::DeliverableCommentsController < Api::V1::ApiController
	respond_to :json
	def default_serializer_options
	  {root: 'comment'}
	end

	def index
  	@deliverable = Deliverable.accessible_to(current_user).find(params[:deliverable_id])
  	@comments = @deliverable.comments
  	@comment_types = @comments.map(&:comment_type).uniq
  	render json: {
  		comments: @comments.map { |c| DeliverableCommentSerializer.new(c, root: false) },
  		comment_types: @comment_types.map { |t| t.to_hash },
  		users: @comments.map(&:creator).uniq.map { |u| UserSerializer.new(u, root: false) },
  	}
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
			@parent_object ||= Deliverable.find(params[:deliverable_id]).ensure_editable_by!(current_user)
		end

		# def current_object
		# 	@current_object ||= parent_object.
		# end

end