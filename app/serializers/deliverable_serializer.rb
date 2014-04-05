class DeliverableSerializer < ActiveModel::Serializer
  # embed :ids
  attributes :id, :created_at, :title, :description
  # has_many :deliverable_users
end
