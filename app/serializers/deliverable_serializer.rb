class DeliverableSerializer < ActiveModel::Serializer
  # embed :ids
  attributes :id, :created_at, :title, :description, :completed_by_id
  # has_many :deliverable_users
end
