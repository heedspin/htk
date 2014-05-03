require 'plutolib/active_hash_methods'
class DeliverableRelationType < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Parent'}
  ]
  include Plutolib::ActiveHashMethods
end
