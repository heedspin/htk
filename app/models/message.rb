# == Schema Information
#
# Table name: messages
#
#  id                  :integer          not null, primary key
#  status_id           :integer
#  conversation_id     :integer
#  date                :datetime
#  data                :text
#  envelope_message_id :string(255)
#  identity_hash       :string(255)
#  body_boundary       :string(255)
#  encoded_body        :text
#  subject             :string(1000)
#  created_at          :datetime
#

require 'plutolib/serialized_attributes'
require 'htk_imap/mail_utils'
require 'mail'

class Message < ApplicationModel
	include HtkImap::MailUtils
	attr_accessible :status, :conversation_id, :conversation, :date, :envelope_message_id, :email
	belongs_to_active_hash :status, :class_name => 'LifeStatus'
	belongs_to :conversation
	include Plutolib::SerializedAttributes

	serialized_attribute :to_addresses
	serialized_attribute :from_addresses
	serialized_attribute :cc_addresses

	def self.user(user, party_role=PartyRole.read_only)
		user_id = user.is_a?(User) ? user.id : user
		joins(conversation: {party: :party_users}).where(party_users: { user_id: user_id, party_role_id: party_role.same_or_better })
	end

	def participants
		@participants ||= (to_addresses + from_addresses + cc_addresses).uniq
	end

	# Htk::Email obj
	attr_accessor :email
	def email=(e)
		@email = e
		if self.encoded_body.present?
			raise 'Updating message is not implemented'
		end
		# @mail = @email.mail
		self.body_boundary = @email.mail.body.boundary
		self.encoded_body = strip_attachments(@email.mail.body).encoded_body
    self.identity_hash = @email.body_identity_hash
    self.from_addresses = @email.from_addresses
    self.to_addresses = @email.to_addresses
    self.cc_addresses = @email.cc_addresses
		self.envelope_message_id = @email.envelope_message_id
		self.subject = @email.subject
		self.date = @email.date
    @email
	end

	def mail_body
		if @mail_body.nil?
			@mail_body = Mail::Body.new(self.encoded_body)
 			@mail_body.boundary = self.body_boundary
 			@mail_body.split!(self.body_boundary)
		end
		@mail_body
	end

	def text_body
		@text_body ||= self.find_content_type(self.mail_body, 'text/plain')
	end

	# Mail obj
	# attr_accessor :mail
	# def mail
	# 	if @mail.nil?
	# 		if self.email.present?
	# 			@mail = self.email.mail
	# 		elsif self.encoded_mail.present?
	# 			@mail = Mail.new(self.encoded_mail)
	# 		end
	# 	end
	# 	@mail
	# end
	# def mail=(m)
	# 	self.encoded_mail = nil
	# 	@mail = m
	# end

	def equals_email?(email)
		message_ids_match = (email.envelope_message_id == self.envelope_message_id)
		# identity_hashes_match = (email.body_identity_hash == self.identity_hash)
		# encoded_mails_match = (email.encoded_body == self.encoded_body)
		# if message_ids_match
		# 	puts "Found matching message-id.  identity_hashes_match=#{identity_hashes_match}, encoded_mails_match=#{encoded_mails_match}"
		# 	puts '-----------------------------------------------------------------------------------------------------------'
		# 	puts email.encoded_body
		# 	puts '-----------------------------------------------------------------------------------------------------------'
		# 	puts self.encoded_body
		# 	puts '==========================================================================================================='
		# end
		# message_ids_match
	end

end
