require 'plutolib/active_hash_methods'
class DeliverableVisibility < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Shown'},
    {:id => 2, :name => 'Hidden'}
  ]
  include Plutolib::ActiveHashMethods
end
