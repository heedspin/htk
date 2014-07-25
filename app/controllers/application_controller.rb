require 'plutolib/format_helper'
require 'htk_current_user'
require 'exceptions/access_denied'
require 'menu_selected'
class ApplicationController < ActionController::Base
  protect_from_forgery
	before_filter :authenticate_user!
  before_filter :record_current_user
	helper Plutolib::FormatHelper
  include MenuSelected

	def not_found
		raise ActiveRecord::RecordNotFound.new('Not Found')
	end
  
  protected
  
    def record_current_user
      HtkCurrentUser.user = current_user
    end

    rescue_from Exceptions::AccessDenied, with: :render_access_denied
    def render_access_denied
      render json: { error: 'access denied' }, status: 403
    end
end
