class Api::V1::EmailCommentsController < Api::V1::ApiController
	respond_to :json
	def default_serializer_options
	  {root: 'comment'}
	end

	def index
		comments = EmailComment.not_deleted.accessible_to(current_user).email_send_time(params[:date_sent]).email_sender(params[:sender_email]).by_created_at_desc.limit(100)
    render json: { comments: comments.map { |c| EmailCommentSerializer.new(c, root: false) }, current_user: EmailCommentUserSerializer.new(current_user, root: false) }
  end
  
  def create
  	if (comment_text = params[:comment]).present? and (sender = params[:sender_email].try(:downcase)).present?
  		participants = ([sender] + [params[:recipient_cc_email]] + [params[:recipient_to_email]]).flatten.compact.map(&:downcase).map(&:strip)
  		if participants.include?(current_user.email)
		  	comment = EmailComment.new(
		  		:status => EmailCommentStatus.published,
		  		:email_sender => sender,
		  		:email_send_time => params[:date_sent],
		  		:email_message_id => params[:message_id],
		  		:format_id => EmailCommentFormat.text.id,
		  		:comment => comment_text
		  	)
	  		EmailComment.transaction do
	  			comment.save!
	  			User.emails(participants).accessible_to(current_user).each do |recipient|
	  				if recipient.id == current_user.id
	  					comment.email_comment_users.create(user_id: current_user.id, role_id: EmailCommentRole.owner.id)
	  				else
	  					comment.email_comment_users.create(user_id: recipient.id, role_id: EmailCommentRole.viewer.id)
	  				end
	  			end
	  		end
	  		render json: comment
	  	else
				render json: { result: 'forbidden' }, status: 403
	  	end
	  else
			render json: { result: 'no comment' }, status: 401
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