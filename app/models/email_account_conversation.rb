# == Schema Information
#
# Table name: email_account_conversations
#
#  id               :integer          not null, primary key
#  status_id        :integer
#  party_id         :integer
#  conversation_id  :integer
#  email_account_id :integer
#  thread_id        :string(255)
#  created_at       :datetime
#

require 'plutolib/logger_utils'

class EmailAccountConversation < ApplicationModel
	include Plutolib::LoggerUtils
	attr_accessible :status, :party, :email_account, :thread_id, :conversation
	belongs_to_active_hash :status, :class_name => 'LifeStatus'
	belongs_to :party
	belongs_to :conversation
	belongs_to :email_account
	validates :thread_id, uniqueness: {scope: :conversation_id}

	# has_many :emails, :dependent => :destroy
	has_one :conversation_import, :dependent => :destroy
	def self.thread_id(thread_id)
		where(:thread_id => thread_id.to_s)
	end
	def self.conversation(conversation)
		where :conversation_id => conversation.is_a?(Conversation) ? conversation.id : conversation
	end
	def self.status(status)
		where :status_id => status.is_a?(LifeStatus) ? status.id : status
	end

	def reload_emails
		thread_emails = self.email_account.emails.thread(self.thread_id).all
		self.email_account.fetch_raw_emails(thread_id: self.thread_id).each do |raw_email|
			email = thread_emails.detect { |e| raw_email.guid == e.guid }
			email ||= self.email_account.emails.build(thread_id: self.thread_id, raw_email: raw_email)
			thread_emails.push(email)
		end
		thread_emails
	end

	def find_conversation_from_messages(messages)
		envelope_message_ids = messages.select do |m| 
			m.participants.include?(self.email_account.username.downcase) 
		end.map(&:envelope_message_id)
		envelope_message_ids.each do |envelope_message_id|
			log "#{self.email_account.username}: Searching for envelope_message_id #{envelope_message_id}"
			if email = self.email_account.fetch_raw_emails(:envelope_message_id => envelope_message_id)
				log "#{self.email_account.username}: Found conversation #{email.thread_id}"
				self.thread_id = email.thread_id
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
