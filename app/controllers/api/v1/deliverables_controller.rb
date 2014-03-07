class Api::V1::DeliverablesController < Api::V1::ApiController
	respond_to :json
	def default_serializer_options
	  {root: 'deliverable'}
	end

	# ActiveModel::Serializer::IncludeError (Cannot serialize deliverable_users when DeliverableSerializer does not have a root!):
	#  app/controllers/api/v1/deliverables_controller.rb:10:in `index'
	def index
		if @email = Email.user(current_user).find_by_web_id(params[:web_id])
			@deliverables = @email.message.message_thread.deliverables.not_deleted
			# render json: deliverables
			render json: { deliverables: @deliverables, email: EmailSerializer.new(@email, root: false) }
			# render json: { deliverables: deliverables.map { |d| DeliverableSerializer.new(d, root: false) }	}
		else
			render json: { result: 'no email' }, status: 404
		end
  end
  
  def create
  	deliverable_title = params[:title] || 'Deliverable'
  	web_id = params[:web_id]
  	email = Email.user(current_user).find_by_web_id(web_id) if web_id
		if email.nil?
  		render json: { result: 'no email' }, status: 422
  	else
  		@deliverable = Deliverable.web_create(email: email, current_user: current_user, title: deliverable_title)
  		render json: @deliverable
	  end
	end

	def update
		if comment = editable_object
			if comment.update_attributes(comment: params[:comment])
				render json: { result: 'success'}
			else
				render json: { errors: comment.errors }, status: 422
			end
		end
	end

	def destroy
		if comment = editable_object
			if comment.destroy
				render json: { result: 'success'}
			else
				render json: { errors: comment.errors }, status: 422
			end	
		end
	end

	protected

		def editable_object
			comment = EmailComment.accessible_to(current_user).find(params[:id]) || not_found
			if comment.owner_email_comment_user.user_id != current_user.id
				render json: { result: 'forbidden' }, status: 403
				nil
			else
				comment
			end
		end
end