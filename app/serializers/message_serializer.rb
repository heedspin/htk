class MessageSerializer < ActiveModel::Serializer
  attributes :id, :message_thread_id
end
