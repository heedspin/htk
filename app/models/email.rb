# == Schema Information
#
# Table name: emails
#
#  id               :integer          not null, primary key
#  email_account_id :integer
#  thread_id        :string(255)
#  folder           :string(255)
#  date             :datetime
#  uid              :string(255)
#  guid             :string(255)
#  subject          :string(255)
#  encoded_mail     :text
#  created_at       :datetime
#  data             :text
#

require 'htk_imap/htk_imap'
require 'email_account_cache'

class Email < ApplicationModel
	include EmailAccountCache	
	include HtkImap::MailUtils
	include ActionView::Helpers::TextHelper
	attr_accessible :folder, :date, :uid, :guid, :subject, :mail, :thread_id, :raw_email
	belongs_to :email_account
	# attr_accessor :email_account_conversations
	attr_accessor :parties
	# has_many :parties, through: :email_account_conversations

	def parties
		@parties ||= []
	end

	scope :by_uid, order(:uid)
	scope :uid_desc, order('emails.uid desc')
	scope :in_party, joins(email_account: :email_account_conversations).where('email_account_conversations.thread_id = emails.thread_id')

	delegate :message_id, to: :mail
	delegate :in_reply_to, to: :mail

	def self.user(user)
		user_id = user.is_a?(User) ? user.id : user
		joins(:email_account).where(email_accounts: { user_id: user_id })
	end
	def self.starting_uid(uid)
		where(['emails.uid < ?', uid])
	end
	def self.thread(thread_id)
		where(:thread_id => thread_id)
	end

	def participants
		@participants ||= ((to_addresses || []) + (from_addresses || []) + cc_addresses || []).uniq
	end

	# def email_address_id
	# 	@email_address_id ||= 0
	# 	@email_address_id += 1
	# end

  def envelope_message_id
  	self.mail.message_id
	end

	# truncate subject
	def subject=(text)
		if text.present?
			super(text[0..253])
		else
			super(text)
		end
	end

	def self.attach_to(messages)
		Email.where(:id => messages.map(&:source_email_id)).each do |email|
			messages.each do |message|
				if message.source_email_id == email.id
					message.source_email = email
				end
			end
		end
	end

	serialized_attribute :to_addresses, default: '[]'
	serialized_attribute :from_addresses, default: '[]'
	serialized_attribute :cc_addresses, default: '[]'

	attr_accessor :mail
	def mail=(m)
		self.date = m.date
		self.subject = m.subject
		strip_attachments(m)
		self.encoded_mail = m.encoded
		self.from_addresses = m.from_addrs.uniq.map(&:downcase)
		self.to_addresses = m.to_addrs.uniq.map(&:downcase)
		self.cc_addresses = m.cc_addrs.uniq.map(&:downcase)
		@mail = m
	end
	def mail
		@mail ||= Mail.new(self.encoded_mail)
	end

	attr_accessor :raw_email
	def raw_email=(raw_email)
		%w(folder uid guid thread_id mail).each do |key|
			self.send("#{key}=", raw_email.send(key))
		end
		raw_email
	end

	def text_body
		@text_body ||= self.find_content_type(self.mail.body, 'text/plain')
	end

	def html_body
		if @html_body.nil?
			if @html_body = self.find_content_type(self.mail.body, 'text/html')			  	
		  	if @html_body.include?('</head>')
			  	@html_body = @html_body.slice(@html_body.index('</head>')+7..-1)
			  end
			  @html_body.sub!('</html>', '')
			  @html_body.sub!('<body', '<div')
			  @html_body.sub!('</body>', '</div>')
			  @html_body.gsub!(/<base href="x-msg:\/\/\d+\/">/, '')
			  @html_body.gsub!(/src="cid:[^"]+"/, 'src="#"')
			else
				@html_body = simple_format(self.text_body || '')
			end
	  end
	  @html_body
	end
end
