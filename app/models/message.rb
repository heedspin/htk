# == Schema Information
#
# Table name: messages
#
#  id                  :integer          not null, primary key
#  status_id           :integer          default(2)
#  message_thread_id   :integer
#  envelope_message_id :string(255)
#  source_email_id     :integer
#  created_at          :datetime
#  data                :text
#  user_group_id       :integer
#

require 'extract_email_reply'

class Message < ApplicationModel
	include ExtractEmailReply
	attr_accessible :status_id, :status, :envelope_message_id, :source_email_id, :message_thread_id, :message_thread
	belongs_to_active_hash :status, :class_name => 'LifeStatus'
	belongs_to :source_email, :class_name => 'Email'
	belongs_to :message_thread
	has_many :emails
	belongs_to :user_group
	validates_presence_of :user_group_id

	# def self.user(user, party_role=PartyRole.read_only)
	# 	user_id = user.is_a?(User) ? user.id : user
	# 	joins(conversation: {party: :party_users}).where(party_users: { user_id: user_id, party_role_id: party_role.same_or_better })
	# end
  scope :not_deleted, where(['messages.status_id != ?', LifeStatus.deleted.id])

  %w(participants subject snippet date from_address to_addresses cc_addresses).each do |key|
  	delegate key.to_sym, to: :source_email
  end

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

	def self.build(args)
		args = args.dup
		user_group_id = args.delete(:user_group_id)
		source_email_id = args.delete(:source_email_id)
		message = new(args)
		message.user_group_id = user_group_id
		message.source_email_id = source_email_id
		message
	end

	def self.find_or_build(email)
		emails = Email.user_group(email.user).from_address(email.from_address).date(email.date).includes(:message).all
		same_emails = emails.select { |e| (e.id != email.id) && e.same_email?(email) }
		messages = same_emails.map(&:message).compact.uniq
		if messages.size == 0
			build(source_email_id: email.id, user_group_id: email.user.user_group_id, source_email_id: email.id, status: LifeStatus.active)
		elsif messages.size == 1
			messages.first
		else
			raise "Found #{messages.size} messages from #{email.from_address} at #{email.date}: " + messages.map(&:id).join(', ')
		end
	end

end
