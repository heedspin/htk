# == Schema Information
#
# Table name: messages
#
#  id                  :integer          not null, primary key
#  status_id           :integer
#  message_thread_id   :integer
#  envelope_message_id :string(255)
#  source_email_id     :integer
#  created_at          :datetime
#  data                :text
#

require 'email_account_cache'
require 'extract_email_reply'

class Message < ApplicationModel
	include EmailAccountCache	
	include ExtractEmailReply
	attr_accessible :status_id, :status, :envelope_message_id, :source_email_id, :message_thread_id, :message_thread
	belongs_to_active_hash :status, :class_name => 'LifeStatus'
	belongs_to :source_email, :class_name => 'Email'
	# has_many :deliverable_messages, dependent: :destroy, conditions: {is_related: true}
	# has_many :deliverables, through: :deliverable_messages
	belongs_to :message_thread
	has_many :emails

	# def self.user(user, party_role=PartyRole.read_only)
	# 	user_id = user.is_a?(User) ? user.id : user
	# 	joins(conversation: {party: :party_users}).where(party_users: { user_id: user_id, party_role_id: party_role.same_or_better })
	# end

	delegate :text_body, to: :source_email
	delegate :text_body_without_reply, to: :source_email
	delegate :searchable_text, to: :source_email
	delegate :html_body, to: :source_email
	delegate :participants, to: :source_email
	delegate :subject, to: :source_email
	delegate :date, to: :source_email
	delegate :from_address, to: :source_email
	delegate :to_addresses, to: :source_email
	delegate :cc_addresses, to: :source_email
	delegate :participants, to: :source_email
	delegate :message_id, to: :source_email
	delegate :in_reply_to, to: :source_email

	def equals_email?(email)
		email.envelope_message_id == self.envelope_message_id
	end

	def parent_message
		if (parent_message_id = self.in_reply_to) and 
			(parent_message = self.conversation.messages.detect { |p| p.message_id == parent_message_id } )
			parent_message
		else
			nil
		end
	end

	def searchable_text
		self.subject + ' ' + self.text_body_without_reply
		# if self.cached_searchable_text
		# 	self.cached_searchable_text
		# else
		# 	self.subject + ' ' + self.text_body_without_reply
		# end
	end

	def text_body_without_reply
		self.extract_email_reply self.text_body
	end

	def self.find_or_build(email)
		emails = Email.from_address(email.from_address).date(email.date).includes(:message).all
		same_emails = emails.select { |e| e.same_email?(email) }
		messages = same_emails.map(&:message).uniq
		if messages.size == 0
			Message.new source_email_id: email.id, status: LifeStatus.active
		elsif messages.size == 1
			messages.first
		else
			raise "Found #{messages.size} messages from #{email.from_address} at #{email.date}: " + messages.map(&:id).join(', ')
		end
	end

end
