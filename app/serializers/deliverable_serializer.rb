class DeliverableSerializer < ActiveModel::Serializer
  # embed :ids
  attributes :id, :created_at, :title, :description, :completed_by_id, :deliverable_type_id
  # has_many :deliverable_users
  def deliverable_type_id
  	DeliverableTypeConfig.where(ar_type: object.type).first.try(:id)
  end
end
