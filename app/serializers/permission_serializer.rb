class PermissionSerializer < ActiveModel::Serializer
  attributes :id, :deliverable_id, :user_id, :responsible, :access_id, :priority_id, :visibility_id
end
