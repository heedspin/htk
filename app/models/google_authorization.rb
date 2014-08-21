# == Schema Information
#
# Table name: google_authorizations
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  gplus_id      :string(255)
#  refresh_token :string(255)
#  access_token  :string(255)
#  expires_in    :integer
#  issued_at     :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'google/api_client'
require 'google/api_client/client_secrets'
require 'net/https'
require 'uri'
require 'cgi'

class GoogleAuthorization < ApplicationModel
	belongs_to :user
	attr_accessible :user_id, :access_token, :refresh_token, :expires_in, :issued_at, :gplus_id

	def self.user(user)
		where user_id: user.is_a?(User) ? user.id : user
	end

	def self.find_or_build(code) 
		log "code = #{code}"
		credentials = GoogleAuthorization.load_credentials
		authorization = Signet::OAuth2::Client.new(
		    authorization_uri: credentials.authorization_uri,
		    token_credential_uri: credentials.token_credential_uri,
		    client_id: credentials.client_id,
		    client_secret: credentials.client_secret,
		    redirect_uri: 'postmessage',
		    scope: 'https://www.googleapis.com/auth/plus.login')

    authorization.code = code
    authorization.fetch_access_token!
    id_token = authorization.id_token
    encoded_json_body = id_token.split('.')[1]
    # Base64 must be a multiple of 4 characters long, trailing with '='
    encoded_json_body += (['='] * (encoded_json_body.length % 4)).join('')
    json_body = Base64.decode64(encoded_json_body)
    body = JSON.parse(json_body)
    # You can read the Google user ID in the ID token.
    # "sub" represents the ID token subscriber which in our case
    # is the user ID. This sample does not use the user ID.
    gplus_id = body['sub']
    google_authorization = self.find_by_gplus_id(gplus_id)
    if google_authorization.nil?
    	google_authorization = new(gplus_id: gplus_id)
    end
    google_authorization.refresh_token = authorization.refresh_token if authorization.refresh_token.present?
    google_authorization.access_token = authorization.access_token
    google_authorization.expires_in = authorization.expires_in
    google_authorization.issued_at = authorization.issued_at
    google_authorization
	end

	def credentials
		@credentials ||= GoogleAuthorization.load_credentials
	end

	def reauthorize!
		client = self.get_client
		client.refresh_authorization!
		if client.authorization.access_token != self.access_token
			self.update_attributes!(access_token: client.authorization.access_token, 
				expires_in: client.authorization.expires_in, 
				issued_at: Time.now)
		end
	end
	
	def seconds_until_expiration
		self.expires_in - (Time.now.to_i - self.issued_at.to_i)
	end

	def get_client
		client = Google::APIClient.new({
			application_name: '126bps GPlus Auth',
			application_version: '1.0',
			auto_refresh_token: true,
			retries: 1,
			client_id: self.credentials.client_id,
	    client_secret: self.credentials.client_secret
		})
		client.authorization.update_token!({ 
			refresh_token: self.refresh_token,
			access_token: self.access_token,
			expires_in: self.expires_in,
			issued_at: self.issued_at
		})
		client

    # id_token = @client.authorization.id_token
    # encoded_json_body = id_token.split('.')[1]
    # # Base64 must be a multiple of 4 characters long, trailing with '='
    # encoded_json_body += (['='] * (encoded_json_body.length % 4)).join('')
    # json_body = Base64.decode64(encoded_json_body)
    # body = JSON.parse(json_body)
    # # You can read the Google user ID in the ID token.
    # # "sub" represents the ID token subscriber which in our case
    # # is the user ID. This sample does not use the user ID.
    # gplus_id = body['sub']
	end

	def with_client!(&block)
		client = self.get_client
		result = nil
		begin
			result = yield(client)
		rescue Google::APIClient::ClientError => e
			# e.message is set to a stringified json object.  google api client fail.
			if (e.result.status == 400) and (e.message.include? 'invalid_grant')
				# Access has been revoked.  This will update db in ensure block.
				client.authorization.update_token!(access_token: nil, refresh_token: nil, expires_in: nil, issued_at: nil)
			end
			raise e
		rescue
			raise $!
		ensure
			if client.authorization.access_token != self.access_token
				self.update_attributes!(access_token: client.authorization.access_token, 
					refresh_token: client.authorization.refresh_token,
					expires_in: client.authorization.expires_in, 
					issued_at: Time.now)
			end
		end
		result
	end

	def self.load_credentials
		Google::APIClient::ClientSecrets.new({'web' => AppConfig.google_api_credentials})
	end

	def disconnect
	  # Use either the refresh or access token to revoke if present.
	  token = self.refresh_token || self.access_token
	  # Send the revocation request and return the result.
	  revokePath = 'https://accounts.google.com/o/oauth2/revoke?token=' + token
	  uri = URI.parse(revokePath)
	  request = Net::HTTP.new(uri.host, uri.port)
	  request.use_ssl = true
	  logger.info "GoogleAuthorization.disconnect: #{uri.request_uri}"
	  request.get(uri.request_uri).code
	end

	def authorized?
		self.access_token.present? && self.refresh_token.present?
	end
end
