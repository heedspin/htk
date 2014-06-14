require 'plutolib/active_hash_methods'
class DeliverableTypeConfig < ActiveHash::Base
  self.data = [
    { :id => 1, 
    	:name => 'Standard', 
    	:js_controller => 'StandardDeliverablesController', 
    	:ar_type => 'StandardDeliverable'
    },
    { :id => 2, 
    	:name => 'LXD Opportunity', 
    	:js_controller => 'LxdOpportunitiesController', 
    	:ar_type => 'LxdOpportunity'
    }
  ]
  include Plutolib::ActiveHashMethods

  def ar_type_class
    self.ar_type.constantize
  end

  def deliverable_type
    @deliverable_type ||= DeliverableType.where(deliverable_type_config_id: self.id).first
  end
end
