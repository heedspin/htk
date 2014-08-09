class GplusAuthsController < ApplicationController
	skip_before_filter :verify_authenticated_user!

	def connect
    google_authorization = GoogleAuthorization.find_or_build(request.body.read)
    user = google_authorization.user || User.new
  	google_authorization.with_client! do |client| 
  		response = client.execute!(client.discovered_api('plus', 'v1').people.get, { userId: 'me' })
  		person = JSON.parse(response.body)
  		user.email = person['emails'].first['value']
  		name = person['name']
  		user.first_name = name['givenName']
  		user.last_name = name['familyName']
		end
		User.connection.transaction do
	    user.save!
	    google_authorization.user_id = user.id
	    google_authorization.save!
	    sign_in user
	  end
    if true
	    render text: '', status: 200
    else
			render json: { error: 'The client state does not match the server state.' }, status: 401
    end
	  # end
	end

	def disconnect
		if ga = current_user.google_authorization
		  render text: '', status: ga.disconnect
		else
		  render text: 'No stored credentials', status: 401
		end
	end

	def profile
		begin
			response = current_user.google_authorization.with_client! do |c| 
				c.execute!(c.discovered_api('plus', 'v1').people.get, { userId: 'me' }) 
			end
			render json: JSON.parse(response.body), status: 200
		rescue Google::APIClient::TransmissionError => e
			if e.result.status == 401
				log_error "Signing out user"
				sign_out
			end
			render json: { error: e.result.error_message }, status: e.result.status
		rescue => e
			log_error "Unhandled error", e
			render json: { error: e.message }, status: 500
		end
	end
end