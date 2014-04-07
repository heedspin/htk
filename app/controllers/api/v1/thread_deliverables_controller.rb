class Api::V1::ThreadDeliverablesController < Api::V1::ApiController
	respond_to :json
	def default_serializer_options
	  {root: 'thread_deliverable'}
	end

  def create
  	deliverable_title = params[:title] || 'Deliverable'
  	web_id = params[:web_id]
  	email = Email.user(current_user).find_by_web_id(web_id) if web_id
		if email.nil?
  		render json: { result: 'no email' }, status: 422
  	else
	  	deliverable = Deliverable.new(:title => deliverable_title)
  		Deliverable.transaction do
  			deliverable.save!
		  	deliverable.messages << email.message
  			User.email_accounts(email.participants).accessible_to(current_user).each do |recipient|
  				access = if recipient.id == current_user.id
  					DeliverableAccess.owner
  				else
  					DeliverableAccess.edit
  				end
  				deliverable.deliverable_users.create!(user_id: recipient.id, access_id: access.id)
  			end
  		end
  		render json: deliverable
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

end