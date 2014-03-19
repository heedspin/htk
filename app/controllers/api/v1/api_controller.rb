require 'oauth' 
require 'openssl'
require 'plutolib/oauth_rails3_request_proxy'
require 'plutolib/logger_utils'

class Api::V1::ApiController < ActionController::Base
	respond_to :json
  before_filter :verify_signed
  before_filter :verify_signed_user
  include Plutolib::LoggerUtils

	protected

	  def verify_signed
	  	if Rails.env.development?
	  		return if current_user
	  	elsif Rails.env.test?
	  		return
	  	end
	  	if (cert_id = params[:xoauth_public_key]) and (cert_file = File.join(Rails.root, 'config/certificates', cert_id)) and File.exists?(cert_file)
		    cert = OpenSSL::X509::Certificate.new(File.read(cert_file))
		    public_key = OpenSSL::PKey::RSA.new(cert.public_key)
		    req = Plutolib::OauthRails3RequestProxy.new(request)
		    cus = OAuth::Consumer.new(params[:oauth_consumer_key] || '',public_key)
		    sign = OAuth::Signature::RSA::SHA1.new(req, {consumer: cus})
		    if sign.verify
		    	opensocial_owner_id = params[:opensocial_owner_id]
		    	opensocial_container = params[:opensocial_container]
		    	logger.info "API: Verified request from opensocial_owner_id=#{opensocial_owner_id}, opensocial_container=#{opensocial_container}"
		    	# Request is signed.  
		    else
		    	logger.info 'API: Rejected Signed Request: ' + req.signature_base_string.inspect
					render json: { error: 'Not Allowed' }, status: 403
		    end
		  else
		  	render json: { error: 'No Certificate' }, status: 401
		  end
	  end

	  def verify_signed_user
	  	return if current_user # When API is called while user logged in.
	  	opensocial_owner_id = params[:opensocial_owner_id]
	  	opensocial_container = params[:opensocial_container]
	  	if opensocial_owner_id.nil? or opensocial_container.nil?
    		render json: { error: 'Please sign in.'}, :status => :unauthorized
    	else
	    	# logger.info 'API: Verified Signed Request: ' + req.signature_base_string.inspect
	    	api_user = SignedRequestUser.owner_container(opensocial_owner_id, opensocial_container).first
	    	if api_user.nil?
	    		logger.info "User failed to sign in using: #{opensocial_owner_id} #{opensocial_container}"
	    		render json: { error: 'Please sign in.'}, :status => :unauthorized
	    	else
	    		sign_out(:user)
					sign_in(:user, api_user.user)
	    	end
	    end
		end

end