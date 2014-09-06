module GetDeliverableTree
	def get_deliverable_tree(args)
		relations = args[:relations]
		relations = [relation] if relations.nil? and (relation = args[:relation])
		deliverables = args[:deliverables]
		if relations.nil? and deliverables
			relations = DeliverableRelation.parent_relation.deliverables(deliverables)
		end
		@relations = DeliverableRelation.get_trees(relations)
		@relations +=  DeliverableRelation.get_companies(@relations)
		deliverable_ids = @relations.map { |r| [r.source_deliverable_id, r.target_deliverable_id] }.flatten
		@deliverables = Deliverable.not_deleted.where(:id => deliverable_ids)
		if deliverables
			@deliverables = @deliverables.excluding(deliverables).all + deliverables
		end
		@deliverable_types = DeliverableType.deliverable_types(@deliverables.map(&:type)).all		
		@permissions = @deliverables.map(&:significant_permissions).flatten.uniq
		if args[:serialize]
			{ 
				deliverables: @deliverables.map { |d| DeliverableSerializer.new(d, root: false) }, 
				permissions: @permissions.map { |p| PermissionSerializer.new(p, root: false) },
				users: @permissions.map(&:user).uniq.map { |u| UserSerializer.new(u, root: false) },
				deliverable_relations: @relations.map { |r| DeliverableRelationSerializer.new(r, root: false) },
				deliverable_types: @deliverable_types.map { |t| DeliverableTypeSerializer.new(t, root: false) }
			}
		else
			{ 
				deliverables: @deliverables, 
				permissions: @permissions,
				users: @permissions,
				deliverable_relations: @relations,
				deliverable_types: @deliverable_types
			}
		end
	end
end