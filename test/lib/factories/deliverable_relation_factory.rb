class DeliverableRelationFactory
	class << self
		def create(args)
			args = args.dup
			args[:relation_type_id] ||= DeliverableRelationType.parent.id
			args[:status_id] ||= LifeStatus.active.id
			DeliverableRelation.create(args)
		end
	end
end