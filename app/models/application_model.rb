require 'plutolib/serialized_attributes'
require 'plutolib/plutobug' if Rails.env.test?
require 'plutolib/logger_utils'
class ApplicationModel < ActiveRecord::Base
	include Plutolib::LoggerUtils
	include Plutolib::SerializedAttributes
  self.abstract_class = true
  extend ActiveHash::Associations::ActiveRecordExtensions

  def self.json_root
  	self.name.underscore
  end
end
