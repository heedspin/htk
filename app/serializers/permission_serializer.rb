class PermissionSerializer < ActiveModel::Serializer
  attributes :id, :deliverable_id, :user_id, :group_id, :responsible, :access_id
end
