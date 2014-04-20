require 'plutolib/format_helper'
require 'htk_current_user'
class ApplicationController < ActionController::Base
  protect_from_forgery
	before_filter :authenticate_user!
  before_filter :record_current_user
	helper Plutolib::FormatHelper

	def not_found
		raise ActiveRecord::RecordNotFound.new('Not Found')
	end
  
  protected
  
    def record_current_user
      HtkCurrentUser.user = current_user
    end
end
