require 'plutolib/active_hash_methods'
class EmailCommentStatus < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Published'},
    {:id => 2, :name => 'Deleted'}
  ]
  include Plutolib::ActiveHashMethods
end
