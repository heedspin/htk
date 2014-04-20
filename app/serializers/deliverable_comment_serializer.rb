class DeliverableCommentSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :note, :creator_id, :creator_first_name, :creator_last_name

  def creator_first_name
  	object.creator.first_name || object.creator.email.split('@').first
  end

  def creator_last_name
  	object.creator.last_name
  end
end
