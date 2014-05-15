class DeliverableSerializer < ActiveModel::Serializer
  # embed :ids
  attributes :id, :created_at, :title, :description, :completed_by_id, :deliverable_type_key
  # has_many :deliverable_users
  def deliverable_type_key
  	object.deliverable_type.try(:key)
  end
end
