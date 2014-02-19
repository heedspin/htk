class DeliverableSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :created_at, :title
  has_many :deliverable_users

  def creator_id
  	object.owner.id
  end

  def creator_first_name
  	object.owner.first_name || object.owner.email.split('@').first
  end

  def creator_last_name
  	object.owner.last_name
  end
end
