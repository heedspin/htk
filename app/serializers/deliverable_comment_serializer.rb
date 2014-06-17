class DeliverableCommentSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :note, :creator_id, :comment_type_id
end
