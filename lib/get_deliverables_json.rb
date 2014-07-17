module GetDeliverablesJson
	def get_deliverables_json(relations)
		relations = [relations] unless relations.is_a?(Array)
		@relations = DeliverableRelation.get_trees(relations)
		deliverable_ids = @relations.map { |r| [r.source_deliverable_id, r.target_deliverable_id] }.flatten
		@deliverables = Deliverable.not_deleted.where(:id => deliverable_ids)
		@deliverable_types = DeliverableType.deliverable_types(@deliverables.map(&:type)).all		
		@permissions = @deliverables.map(&:significant_permissions).flatten.uniq
		{ 
			deliverables: @deliverables.map { |d| DeliverableSerializer.new(d, root: false) }, 
			permissions: @permissions.map { |p| PermissionSerializer.new(p, root: false) },
			users: @permissions.map(&:user).uniq.map { |u| UserSerializer.new(u, root: false) },
			deliverable_relations: @relations.map { |r| DeliverableRelationSerializer.new(r, root: false) },
			deliverable_types: @deliverable_types.map { |t| DeliverableTypeSerializer.new(t, root: false) }
		}
	end
end