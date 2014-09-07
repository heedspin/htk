# == Schema Information
#
# Table name: emails
#
#  id                      :integer          not null, primary key
#  email_account_id        :integer
#  message_id              :integer
#  email_account_thread_id :integer
#  thread_id               :string(255)
#  web_id                  :string(255)
#  folder                  :string(255)
#  date                    :datetime
#  uid                     :integer
#  guid                    :string(255)
#  from_address            :string(255)
#  subject                 :string(255)
#  encoded_mail            :text
#  data                    :text
#  created_at              :datetime
#  user_id                 :integer
#  snippet                 :string(255)
#  status_id               :integer          default(2)
#

require 'htk_imap/htk_imap'

class Email < ApplicationModel
	include HtkImap::MailUtils
	include ActionView::Helpers::TextHelper
	attr_accessible :folder, :date, :uid, :guid, :subject, :from_address, :mail, :thread_id, :raw_email, :message, :web_id, :user, :user_id, :snippet, :message_wrapper, :status, :status_id
	belongs_to :email_account
	belongs_to :message
	belongs_to :email_account_thread
	has_one :message_thread, through: :message
	belongs_to :user
	belongs_to_active_hash :status, :class_name => 'LifeStatus'

	# TODO: rake db:migrate:down VERSION=20130817143155
	scope :by_uid, order(:uid)
	scope :uid_desc, order('emails.uid desc')
	scope :date_desc, order('emails.date desc')
  scope :not_deleted, where(['emails.status_id != ?', LifeStatus.deleted.id])
  scope :deleted, where(status_id: LifeStatus.deleted.id)

	def self.user(user)
		user_id = user.is_a?(User) ? user.id : user
		where user_id: user_id
	end
	def self.starting_uid(uid)
		where(['emails.uid < ?', uid])
	end
	def self.thread(thread_id)
		where(thread_id: thread_id)
	end
	def self.from_address(from_address)
		where ['lower(emails.from_address) = ?', from_address.try(:downcase)]
	end
	def self.sanitize_date(date)
		date = case date
		when String
			# Convert GMail epoch time to datetime
			DateTime.strptime(date[0..9], '%s')
		when DateTime
			date.change usec: 0
		when Time
			date.change usec: 0
		end
		date
	end
	def self.date(date)
		where date: self.sanitize_date(date)
	end
	def date=(date)
		super self.class.sanitize_date(date)
	end
	def self.web_id(web_id)
		where web_id: web_id
	end
	def self.between(start_date, end_date)
		where ['emails.date >= ? and emails.date <= ?', start_date, end_date]
	end
	def self.subject(txt)
		where ['emails.subject = ?', txt]
	end
	def self.message(message)
		message_id = message.is_a?(Message) ? message.id : message
		where(message_id: message_id)
	end

	def participants
		@participants ||= ((to_emails || []) + [from_email] + (cc_emails || [])).compact.uniq
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

	attr_accessible :to_addresses, :cc_addresses
	serialized_attribute :to_addresses, default: '[]'
	serialized_attribute :cc_addresses, default: '[]'
	%w(to cc).each do |key|
		class_eval <<-RUBY
		def #{key}_addresses=(val)
			unless val.is_a?(Array)
				val = [val]
			end
			self.data['#{key}_addresses'] = val
		end
		def #{key}_emails
			self.#{key}_addresses.map do |addr| 
				name, email = Plutolib::RegexUtils.extract_email_parts(addr)
				email
			end
		end
		RUBY
	end

	serialized_attribute :header_message_id
	serialized_attribute :label_ids

	def first_names_to_users
		alias_emails = []
		first_names = self.to_addresses.map do |addr| 
			name, email = Plutolib::RegexUtils.extract_email_parts(addr)
			if first_name = name && name.split(' ').first.capitalize
				alias_emails.push [first_name.downcase, name, email]
			end
		end
		users = User.emails(alias_emails.map(&:last)).all
		result = {}
		alias_emails.each do |first_name, name, email|
			u = users.first { |u| u.email == name_email.last }
			u ||= User.build(email: email, name: name, status: UserStatus.inactive, user_group_id: nil)
			result[first_name] = u unless result.member?(first_name)			
			if (user_first_name = u.first_name.try(:downcase)) and user_first_name != first_name
				result[user_first_name] = u unless result.member?(user_first_name)
			end
		end
		result
	end

	def from_email
		self.from_user.email
	end

	def from_user
		if @from_user.nil?
			name, email = Plutolib::RegexUtils.extract_email_parts(self.from_address)
			@from_user = User.email(email).first ||	User.build(email: email, name: name, status: UserStatus.inactive, user_group_id: nil)
		end
		@from_user
	end

	attr_accessor :mail
	def mail=(m)
		self.date = m.date
		self.subject = m.subject
		strip_attachments(m)
		self.encoded_mail = m.encoded
		self.from_address = m.from_addrs.uniq.first.try(:downcase)
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

	attr_accessor :message_wrapper
	def message_wrapper=(mw)
		if @message_wrapper = mw
			[[:web_id, :id], [:label_ids, :labelIds], :header_message_id,
				:thread_id, :date, :subject, :from_address, :to_addresses, :cc_addresses, :snippet].each do |key|
				if key.is_a?(Array)
					email_key = key.first
					mw_key = key.last
				else
					email_key = mw_key = key
				end
				self.send("#{email_key}=", mw.send(mw_key))
			end
		end
	end
	def message_wrapper
		@message_wrapper ||= self.user.gmail_synchronization.get_email(self)
	end

	def resync!
		case self.user.gmail_synchronization.resync_email(self)
		when :changed
			self.save!
		when :deleted
			self.destroy
		else
			false
		end
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

	def same_email?(email)
		(self.from_address == email.from_address) && 
		(self.date.to_i == email.date.to_i) && 
		(self.to_addresses.try(:sort) == email.to_addresses.try(:sort)) && 
		(self.cc_addresses.try(:sort) == email.cc_addresses.try(:sort))
	end

	def destroy
		self.status = LifeStatus.deleted
		self.save!
	end

	def find_duplicates
		self.user.emails.where('emails.id != ?', self.id).from_address(self.from_address).date(self.date).all
	end

	def to_s
		"#{self.user.email}: #{self.web_id} from #{self.from_address} on #{self.date} in #{(self.label_ids || []).join(',')} #{self.subject} - #{self.snippet}"
	end
end
