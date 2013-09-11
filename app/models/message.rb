# == Schema Information
#
# Table name: messages
#
#  id                  :integer          not null, primary key
#  status_id           :integer
#  conversation_id     :integer
#  envelope_message_id :string(255)
#  source_email_id     :integer
#  created_at          :datetime
#  data                :text
#

require 'email_account_cache'

class Message < ApplicationModel
	include EmailAccountCache	
	attr_accessible :status_id, :date, :hidden, :status, :conversation_id, :conversation, :envelope_message_id, :source_email_id
	belongs_to_active_hash :status, :class_name => 'LifeStatus'
	belongs_to :conversation
	has_many :emails
	belongs_to :source_email, :class_name => 'Email'

	def self.user(user, party_role=PartyRole.read_only)
		user_id = user.is_a?(User) ? user.id : user
		joins(conversation: {party: :party_users}).where(party_users: { user_id: user_id, party_role_id: party_role.same_or_better })
	end

	serialized_attribute :hidden, default: 'false'

	delegate :text_body, to: :source_email
	delegate :searchable_text, to: :source_email
	delegate :html_body, to: :source_email
	delegate :participants, to: :source_email
	delegate :subject, to: :source_email
	delegate :date, to: :source_email
	delegate :from_addresses, to: :source_email
	delegate :to_addresses, to: :source_email
	delegate :cc_addresses, to: :source_email
	delegate :participants, to: :source_email

	def equals_email?(email)
		email.envelope_message_id == self.envelope_message_id
	end
end
