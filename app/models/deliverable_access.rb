require 'plutolib/active_hash_methods'
class DeliverableAccess < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Owner'},
    {:id => 2, :name => 'Edit'},
    {:id => 3, :name => 'Read'}
  ]
  include Plutolib::ActiveHashMethods
end
