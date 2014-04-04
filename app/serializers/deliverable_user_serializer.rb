class DeliverableUserSerializer < ActiveModel::Serializer
  attributes :id, :deliverable_id, :user_id, :responsible, :access
  def access
  	object.access.cmethod
  end
end
