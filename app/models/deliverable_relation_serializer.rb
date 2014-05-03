class DeliverableRelationSerializer < ActiveModel::Serializer
  attributes :source_deliverable_id, :target_deliverable_id, :relation_type

  def relation_type
  	object.relation_type.cmethod
  end
end
