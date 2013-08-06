require 'plutolib/active_hash_methods'
class EmailAccountStatus < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Unclaimed'},
    {:id => 2, :name => 'Active'},
    {:id => 3, :name => 'Deleted'}
  ]
  include Plutolib::ActiveHashMethods
end
