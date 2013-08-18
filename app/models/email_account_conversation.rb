# == Schema Information
#
# Table name: email_account_conversations
#
#  id                    :integer          not null, primary key
#  status_id             :integer
#  party_id              :integer
#  conversation_id       :integer
#  email_account_id      :integer
#  email_conversation_id :string(255)
#  created_at            :datetime
#

require 'plutolib/logger_utils'

class EmailAccountConversation < ApplicationModel
	include Plutolib::LoggerUtils
	attr_accessible :status, :party, :email_account, :email_conversation_id, :conversation
	belongs_to_active_hash :status, :class_name => 'LifeStatus'
	belongs_to :party
	belongs_to :conversation
	belongs_to :email_account
	validates_uniqueness_of :email_conversation_id, scope: :party_id
	has_many :message_receipts, :dependent => :destroy
	has_one :conversation_import, :dependent => :destroy
	def self.email_conversation_id(email_conversation_id)
		where(:email_conversation_id => email_conversation_id.to_s)
	end
	def self.conversation(conversation)
		where :conversation_id => conversation.is_a?(Conversation) ? conversation.id : conversation
	end
	def self.status(status)
		where :status_id => status.is_a?(LifeStatus) ? status.id : status
	end

	def fetch_emails
		self.email_account.fetch_emails(email_conversation_id: self.email_conversation_id)
	end

	def find_conversation_from_messages(messages)
		message_ids = messages.select do |m| 
			m.participants.include?(self.email_account.username.downcase) 
		end.map(&:envelope_message_id)
		message_ids.each do |message_id|
			log "#{self.email_account.username}: Searching for message-id #{message_id}"
			if email = self.email_account.fetch_email(:message_id => message_id)
				log "#{self.email_account.username}: Found conversation #{email.email_conversation_id}"
				self.email_conversation_id = email.email_conversation_id
				return true
			end
		end
		log "#{self.email_account.username}: Failed to find email conversation"
		return false
	end

	def update_import!(args={})
		asynchronous = args[:asynchronous]
		import = ConversationImport.new(email_account_conversation: self, process_pending_imports: args[:process_pending_imports])
		if asynchronous
			import.run_in_background!
		else
			import.run_report
		end
	end

	protected

		validates :email_conversation_id, uniqueness: {scope: :conversation_id}

		# class NotAlreadyImportedValidator < ActiveModel::EachValidator
		#   def validate_each(record, attribute, value)
		# 		if record.party and record.email_account and record.email_conversation_id
		# 			if ea_conv = record.email_account.email_account_conversations.email_conversation_id(value).first
		# 				record.errors.add(attribute, "This thread is already imported to party #{ea_conv.try(:party).try(:name)}")
		# 			end
		# 		end
		#   end
		# end
		# validates :email_conversation_id, not_already_imported: true, on: :create

end
