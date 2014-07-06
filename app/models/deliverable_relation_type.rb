require 'plutolib/active_hash_methods'
class DeliverableRelationType < ActiveHash::Base
  self.data = [
    {id: 1, name: 'Parent'},
    {id: 2, name: 'Company'}
  ]
  include Plutolib::ActiveHashMethods
end
