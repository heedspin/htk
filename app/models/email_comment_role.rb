require 'plutolib/active_hash_methods'
class EmailCommentRole < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Owner'},
    {:id => 2, :name => 'Viewer'}
  ]
  include Plutolib::ActiveHashMethods
end
