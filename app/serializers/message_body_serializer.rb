class MessageBodySerializer < ActiveModel::Serializer
  attributes :id, :html_body, :message

  def message
  	object.id
  end
end
