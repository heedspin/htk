class DeliverableRelationSerializer < ActiveModel::Serializer
  attributes :id, :source_deliverable_id, :target_deliverable_id, :relation_type_id, :previous_sibling_id
end
