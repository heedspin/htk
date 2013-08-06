# == Schema Information
#
# Table name: conversation_imports
#
#  id                            :integer          not null, primary key
#  status_id                     :integer
#  email_account_conversation_id :integer
#  process_pending_imports_id    :integer
#  delayed_job_id                :integer
#  delayed_job_status_id         :integer
#  delayed_job_log               :text
#  delayed_job_method            :string(255)
#  user_id                       :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#

require 'plutolib/stateful_delayed_report'

class ConversationImport < ApplicationModel
	include Plutolib::StatefulDelayedReport
	belongs_to_active_hash :status, :class_name => 'LifeStatus'
	belongs_to_active_hash :process_pending_imports
	attr_accessible :status, :email_account_conversation, :process_pending_imports
	belongs_to :email_account_conversation
	has_one :conversation, :through => :email_account_conversation
	has_one :party, :through => :email_account_conversation
	validates :email_account_conversation, presence: true

	def self.create_from_email_conversation_id!(args={})
		party = args[:party] || (raise 'party required')
		email_account = args[:email_account] || (raise 'email_account required')
		email_conversation_id = args[:email_conversation_id] || (raise 'email_conversation_id required')
		conversation = Conversation.create(status: LifeStatus.active, party: party)
		eac = email_account.email_account_conversations.create(status: LifeStatus.importing, 
			party: party,
			conversation: conversation, 
			email_conversation_id: email_conversation_id)
		new(status: LifeStatus.active, email_account_conversation: eac, process_pending_imports: args[:process_pending_imports])
	end

	def email_account
		self.email_account_conversation.email_account
	end

	def should_import?
		!@imported && self.import_authorized? && self.email_conversation_id
	end

	def import_authorized?
		# TODO: authorization
		self.email_account.present?
	end

	def conversation_messages
		@conversation_messages ||= self.conversation.messages.all
	end

	def run_pending_imports
		self.conversation.reload
		self.conversation.email_account_conversations.status(LifeStatus.pending_import).includes(:email_account).each do |eac|
			if eac.email_account.status.active? and can_access_email_account?(eac.email_account)
				new_import = ConversationImport.create(email_account_conversation: eac)
				if self.process_pending_imports.synchronously?
					new_import.run_report
				else
					new_import.run_in_background!
				end
			end
		end
	end

	def run_report
		# return unless self.should_import?
		unless self.email_account_conversation.email_conversation_id
			self.email_account_conversation.find_conversation_from_messages(self.conversation_messages)
		end
		if self.email_account_conversation.email_conversation_id
			self.import_conversation
			self.email_account_conversation.status = LifeStatus.active
		else
			self.email_account_conversation.status = LifeStatus.deleted
		end
		self.email_account_conversation.save!
		self.save!
		if self.process_pending_imports.try(:synchronously?) or self.process_pending_imports.try(:asynchronously?)
			self.run_pending_imports
		end
	end

	def can_access_email_account?(email_account)
		# TODO: Check groups and authorizations.
		true
	end

	def participants
		if @participants.nil?
			@participants = {}
			self.conversation.email_account_conversations.includes(:email_account).each do |eac|
				@participants[eac.email_account.username.downcase] = eac
			end
		end
		@participants
	end

	def add_participant(email_address, message_id)
		eac = self.participants[email_address]
		if eac.nil?
			email_account = EmailAccount.username(email_address).first
			if email_account.nil?
				email_account = EmailAccount.create(status: EmailAccountStatus.unclaimed, username: email_address)
				log "Created unclaimed email account for #{email_address}"
			end
			eac = email_account.email_account_conversations.conversation(self.conversation).first
			if eac.nil?
				eac = email_account.email_account_conversations.create(status: LifeStatus.pending_import, 
					party: self.party,
					conversation: self.conversation)
				log "Created email account conversation for #{email_address} on conversation #{self.conversation.id}"
			end
			self.participants[email_address] = eac
		end
		eac
	end

	def import_conversation
		log "Importing emails from  #{self.email_account.username} to party #{self.party}"
		# self.email_account_conversation.status = LifeStatus.importing # save?
		email_receipts = self.email_account_conversation.email_receipts.all
		self.email_account_conversation.fetch_emails.each do |email|
			email.participants.each do |email_address|
				self.add_participant(email_address, email.envelope_message_id) 
			end
			if receipt = email_receipts.detect { |r| email.equals_receipt?(r) }
				# TODO: Update?
			else
				receipt = self.email_account_conversation.email_receipts.build(
					status_id: LifeStatus.active, 
					email_folder: email.folder, 
					email_uid: email.uid, 
					email_guid: email.guid,
					email: email)
				receipt.transaction do
					unless message = self.conversation_messages.detect { |m| m.equals_email?(email) }
						message = Message.create!(
							status: LifeStatus.active, 
							conversation: self.conversation,
							email: email)
						self.conversation_messages.push message
					end
					receipt.message = message
					receipt.save!
				end
			end
		end
	end
end
