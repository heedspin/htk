class DeliverableRelationSerializer < ActiveModel::Serializer
  attributes :id, :source_deliverable_id, :target_deliverable_id, :relation_type, :previous_sibling_id

  def relation_type
  	object.relation_type.id
  end
end
