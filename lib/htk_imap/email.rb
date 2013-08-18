require 'digest/md5'

class HtkImap::Email
	include ActiveModel::Serializers::JSON
	attr_accessor :mail, :email_conversation_id, :uid, :guid, :mail, :folder

  attr_accessor :attributes
  def initialize
    @attributes = { 'id' => nil, 'date' => nil, 'subject' => nil }
  end

	# delegate :from, to: :mail
	# delegate :to, to: :mail
	# delegate :cc, to: :mail
	delegate :subject, to: :mail
	delegate :date, to: :mail
	alias_method :id, :uid

	def mail=(m)
		# Strip attachments
		self.mail.parts.delete_if { |p| p.content_type.include?('text/plain') || p.content_type.include?('text/html')}
		@encoded_mail = nil
		self.mail
	end

	def participants
		(mail.from_addrs + mail.to_addrs + mail.cc_addrs).uniq.map(&:downcase)
	end

  def envelope_message_id
  	self.mail.message_id
	end

	def encoded_body
		@encoded_body ||= self.mail.body.encoded
	end

	def to_addresses
		self.mail.to_addrs.uniq.map(&:downcase)
	end
	def from_addresses
		self.mail.from_addrs.uniq.map(&:downcase)
	end
	def cc_addresses
		self.mail.cc_addrs.uniq.map(&:downcase)
	end

	def body_identity_hash
		@body_identity_hash ||= Digest::MD5.hexdigest(self.encoded_body)
	end

	def equals_receipt?(r)
		r.email_guid == self.guid
	end

end
