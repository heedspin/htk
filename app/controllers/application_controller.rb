require 'plutolib/format_helper'
class ApplicationController < ActionController::Base
  protect_from_forgery
	before_filter :authenticate_user!
	helper Plutolib::FormatHelper

	def not_found
		raise ActiveRecord::RecordNotFound.new('Not Found')
	end
end
