require 'plutolib/format_helper'
require 'htk_current_user'
require 'exceptions/access_denied'
require 'menu_selected'
require 'plutolib/logger_utils'

class ApplicationController < ActionController::Base
  include Plutolib::LoggerUtils
  protect_from_forgery
	before_filter :verify_authenticated_user!
  before_filter :record_current_user
	helper Plutolib::FormatHelper
  include MenuSelected
  helper_method :gplus_credentials

	def not_found
		raise ActiveRecord::RecordNotFound.new('Not Found')
	end
  
  protected

    def gplus_credentials
      @gplus_credentials ||= GoogleAuthorization.load_credentials
    end
  
    def record_current_user
      HtkCurrentUser.user = current_user
    end

    def verify_authenticated_user!
      unless current_user && current_user.google_authorization.try(:authorized?)
        sign_out
        redirect_to signin_url(r: request.original_fullpath, force: true)
      end
    end

    def reauthorize
      sign_out
      redirect_to signin_url(r: request.original_fullpath)
    end
end
