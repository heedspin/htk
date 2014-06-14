class DeliverableUserSerializer < ActiveModel::Serializer
  attributes :id, :deliverable_id, :user_id, :responsible
end
