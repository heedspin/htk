class Api::V1::EmailsController < Api::V1::ApiController
	respond_to :json
	def default_serializer_options
	  {root: 'email'}
	end
  
  def create
  	to_addresses = params[:to_addresses]
  	cc_addresses = params[:cc_addresses]
		participants = ([params[:from_address]] + [cc_addresses] + [to_addresses]).flatten.compact.map(&:downcase).map(&:strip)
		if !participants.include?(current_user.email)
			log_error "#{current_user.email} can not create email with participants: " + participants.join(', ')
			render json: { result: 'forbidden' }, status: 403
  	else
  		email_account = current_user.email_accounts.first
  		email = email_account.emails.build(date: params[:date],
  			subject: params[:subject], 
  			from_address: params[:from_address], 
  			web_id: params[:web_id],
  			body_brief: params[:body_brief],
  			to_addresses: to_addresses,
  			cc_addresses: cc_addresses)
  		Email.transaction do
	  		message = Message.find_or_create(email)
	  		email.message = message
	  		if email.save	  			
	  			render json: email
	  		else
	  			render json: { errors: email.errors }, status: 422
		  	end
		  end
	  end
	end
end