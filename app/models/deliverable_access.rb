require 'plutolib/active_hash_methods'
class DeliverableAccess < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Read'},
    {:id => 2, :name => 'Edit'}
  ]
  include Plutolib::ActiveHashMethods
end
