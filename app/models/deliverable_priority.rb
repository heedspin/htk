require 'plutolib/active_hash_methods'
class DeliverablePriority < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Low'},
    {:id => 2, :name => 'Medium'},
    {:id => 3, :name => 'High'}
  ]
  include Plutolib::ActiveHashMethods
end
