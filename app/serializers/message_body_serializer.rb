class MessageBodySerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :html_body
  has_one :message

  def message
  	object
  end
end
