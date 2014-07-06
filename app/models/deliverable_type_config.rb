require 'plutolib/active_hash_methods'
class DeliverableTypeConfig < ActiveHash::Base
  self.data = [
    { id: 1, 
    	name: 'Standard', 
    	js_controller: 'StandardDeliverablesController', 
    	ar_type: 'Deliverables::Standard',
      behaviors: [:todo]
    },
    { id: 2, 
      name: 'LXD Opportunity', 
      js_controller: 'LxdOpportunitiesController', 
      ar_type: 'Deliverables::LxdOpportunity',
      behaviors: [:todo]
    },
    { id: 3,
      name: 'Project',
      js_controller: 'ProjectsController',
      ar_type: 'Deliverables::Project',
      behaviors: []
    },
    { id: 4,
      name: 'Company',
      js_controller: 'CompaniesController',
      ar_type: 'Deliverables::Company',
      behaviors: []
    }
  ]
  include Plutolib::ActiveHashMethods

  def ar_type_class
    self.ar_type.constantize
  end

  def deliverable_type
    @deliverable_type ||= DeliverableType.where(deliverable_type_config_id: self.id).first
  end

  def has_behavior?(key)
    self.behaviors.include?(key)
  end
end
