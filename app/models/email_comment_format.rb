require 'plutolib/active_hash_methods'
class EmailCommentFormat < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Text'}
  ]
  include Plutolib::ActiveHashMethods
end
