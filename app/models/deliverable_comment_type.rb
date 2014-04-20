require 'plutolib/active_hash_methods'
class DeliverableCommentType < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Note'},
    {:id => 2, :name => 'Complete'},
    {:id => 3, :name => 'Incomplete'}
  ]
  include Plutolib::ActiveHashMethods
end
