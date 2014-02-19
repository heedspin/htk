require 'plutolib/active_hash_methods'
class DeliverableStatus < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Published'},
    {:id => 2, :name => 'Deleted'}
  ]
  include Plutolib::ActiveHashMethods
end
