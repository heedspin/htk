require 'plutolib/serialized_attributes'
class ApplicationModel < ActiveRecord::Base
	include Plutolib::SerializedAttributes
  self.abstract_class = true
  extend ActiveHash::Associations::ActiveRecordExtensions
end
