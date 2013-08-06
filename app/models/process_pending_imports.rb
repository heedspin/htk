require 'plutolib/active_hash_methods'
class ProcessPendingImports < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'None'},
    {:id => 2, :name => 'Synchronously'},
    {:id => 3, :name => 'Asynchronously'}
  ]
  include Plutolib::ActiveHashMethods
end
