class MessageSerializer < ActiveModel::Serializer
  attributes :id, :subject

  def subject
  	object.source_email.subject
  end
end
