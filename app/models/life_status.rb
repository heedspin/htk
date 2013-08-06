require 'plutolib/active_hash_methods'
class LifeStatus < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Pending Import'},
    {:id => 2, :name => 'Importing'},
    {:id => 3, :name => 'Active'},
    {:id => 4, :name => 'Deleted'}
  ]
  include Plutolib::ActiveHashMethods
end
