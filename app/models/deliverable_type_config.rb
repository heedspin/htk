require 'plutolib/active_hash_methods'
class DeliverableTypeConfig < ActiveHash::Base
  self.data = [
    { id: 1, 
    	name: 'Standard', 
    	js_controller: 'StandardDeliverablesController', 
    	ar_type: 'Deliverables::Standard',
      behaviors: [:todo],
      enable: true
    },
    { id: 2, 
      name: 'LXD Opportunity', 
      js_controller: 'LxdOpportunitiesController', 
      ar_type: 'Deliverables::LxdOpportunity',
      behaviors: [:todo],
      enable: false
    },
    { id: 3,
      name: 'Project',
      js_controller: 'ProjectsController',
      ar_type: 'Deliverables::Project',
      behaviors: [],
      enable: true
    },
    { id: 4,
      name: 'Company',
      js_controller: 'CompaniesController',
      ar_type: 'Deliverables::Company',
      behaviors: [],
      enable: false
    }
  ]
  include Plutolib::ActiveHashMethods

  def ar_type_class
    self.ar_type.constantize
  end

  def deliverable_type(user_group_id)
    DeliverableType.where(deliverable_type_config_id: self.id, user_group_id: user_group_id).first
  end

  def has_behavior?(key)
    self.behaviors.include?(key)
  end

  def enable!(user_group_id)
    self.deliverable_type(user_group_id) || DeliverableType.create!(deliverable_type_config_id: self.id, user_group_id: user_group_id)
  end

  def self.enable!(user_group_id, *args)
    if args.size == 0
      args = self.where(enable: true).map(&:cmethod)
    end
    args.each { |k| self.send(k).enable!(user_group_id) }
  end
end
