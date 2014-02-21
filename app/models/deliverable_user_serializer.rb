class DeliverableUserSerializer < ActiveModel::Serializer
  attributes :id, :responsible, :access_id, :first_name, :last_name
  def first_name
  	object.user.first_name
  end
  def last_name
  	object.user.last_name
  end
end
