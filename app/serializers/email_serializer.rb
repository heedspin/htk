class EmailSerializer < ActiveModel::Serializer
  attributes :id, :date, :email_account_thread_id, :message_thread_id, :message_id

  def message_thread_id
  	object.message.try(:message_thread_id)
  end
end
