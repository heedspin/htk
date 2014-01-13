class EmailCommentSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :format_id, :comment, :creator_id, :creator_first_name, :creator_last_name

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
