# == Schema Information
#
# Table name: email_receipts
#
#  id                            :integer          not null, primary key
#  status_id                     :integer
#  email_account_conversation_id :integer
#  message_id                    :integer
#  email_folder                  :string(255)
#  email_uid                     :string(255)
#  email_guid                    :string(255)
#  encoded_header                :text
#  created_at                    :datetime
#

class EmailReceipt < ApplicationModel
	attr_accessible :status_id, :email_uid, :email_conversation_id, :email, :email_folder, :email_guid
	belongs_to_active_hash :status, :class_name => 'LifeStatus'
	belongs_to :email_account_conversation
	belongs_to :message
	def self.message(message)
		where(:message_id => message.id)
	end

	attr_accessor :email
	def email=(e)
		self.encoded_header = e.mail.header.encoded
	end

	def mail_header
		@mail_header ||= Mail::Header.new(self.encoded_header)
	end

	def destroy
		if self.message
			if EmailReceipt.message(self.message).count == 1
				self.message.destroy
			end
		end
		super
	end
end
