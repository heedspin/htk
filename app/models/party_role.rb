require 'plutolib/active_hash_methods'
class PartyRole < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Read Only'},
    {:id => 2, :name => 'Member'},
    {:id => 3, :name => 'Admin'}
  ]
  include Plutolib::ActiveHashMethods

  def same_or_better
  	(self.id..PartyRole.last.id).to_a
  end
end
