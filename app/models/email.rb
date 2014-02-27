# == Schema Information
#
# Table name: emails
#
#  id                      :integer          not null, primary key
#  email_account_id        :integer
#  thread_id               :string(255)
#  folder                  :string(255)
#  date                    :datetime
#  uid                     :string(255)
#  guid                    :string(255)
#  subject                 :string(255)
#  encoded_mail            :text
#  created_at              :datetime
#  data                    :text
#  from_address            :string(255)
#  web_id                  :string(255)
#  message_id              :integer
#  email_account_thread_id :integer
#

require 'htk_imap/htk_imap'
require 'email_account_cache'

class Email < ApplicationModel
	include EmailAccountCache	
	include HtkImap::MailUtils
	include ActionView::Helpers::TextHelper
	attr_accessible :folder, :date, :uid, :guid, :subject, :mail, :thread_id, :raw_email, :from_address, :web_id
	belongs_to :email_account
	belongs_to :message
	belongs_to :email_account_thread

	scope :by_uid, order(:uid)
	scope :uid_desc, order('emails.uid desc')

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
		where(thread_id: thread_id)
	end
	def self.from_address(from_address)
		where(from_address: from_address.downcase)
	end
	def self.epoch_to_date(date)
		if date.is_a?(String)
			# Convert GMail epoch time to datetime
			DateTime.strptime(date[0..9], '%s')
		else
			date
		end
	end
	def self.date(date)
		where date: epoch_to_date(date)
	end
	def date=(date)
		super self.class.epoch_to_date(date)
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
	def self.web_id(txt)
		where :web_id => txt
	end

	def participants
		@participants ||= ((to_addresses || []) + [from_address] + (cc_addresses || [])).uniq
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

	attr_accessible :to_addresses, :cc_addresses, :body_brief
	serialized_attribute :to_addresses, default: '[]'
	serialized_attribute :cc_addresses, default: '[]'
	serialized_attribute :body_brief, default: 'nil'
	%w(to_addresses cc_addresses).each do |key|
		class_eval <<-RUBY
		def #{key}=(val)
			unless val.is_a?(Array)
				val = [val]
			end
			self.data['#{key}'] = val
		end
		RUBY
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
		(self.date == email.date) && 
		(self.to_addresses.try(:sort) == email.to_addresses.try(:sort)) && 
		(self.cc_addresses.try(:sort) == email.cc_addresses.try(:sort))
	end

	def self.web_create(email_account, params)
		subject = params[:subject]
		date = params[:date]
		email = email_account.emails.build(date: date,
  			subject: subject, 
  			from_address: params[:from_address], 
  			web_id: params[:web_id],
  			body_brief: params[:body_brief],
  			to_addresses: params[:to_addresses],
  			cc_addresses: params[:cc_addresses])
		Email.transaction do
  		message = Message.find_or_create(email)
  		email.message = message
  		if message.email_thread
  			eat = message.email_thread.email_account_threads.email_account(email_account).first
  			if eat.nil?
  				eat = email.create_email_account_thread!(email_account: email_account, email_thread: message.email_thread, subject: subject, start_time: date)
  			elsif email.date < eat.start_time
  				eat.update_attributes start_time: email.date
  			end
				email.email_account_thread = eat
  		else # New message.
  			email_thread = nil
  			# Look for existing thread.
  			related_emails = email_account.emails.between(email.date.advance(:days => -3), email.date.advance(:days => 3)).subject(subject).all
  			if related_emails.size > 0
  				first_email = related_emails.sort_by(&:date).first
  				first_eat = first_email.email_account_thread
  				if email.date < first_eat.start_time
  					first_eat.start_time = email.date
  					first_eat.save!
  				end
  				related_emails.push(email)
  				related_emails.each do |e|
  					if e.email_account_thread != first_eat
  						if e.email_account_thread
  							e.email_account_thread.destroy
  						end
		  				e.email_account_thread = first_eat
		  				e.save!
		  			end
		  		end
  			else # No related emails. Create new thread.
  				# FIX: Email Account Threads do not have email account ids!
  				eat = email.create_email_account_thread!(email_account: email_account, start_time: email.date, subject: subject)
  				email_thread = eat.create_email_thread!
  			end
  			message.update_attributes! email_thread: email_thread
  		end
  		email.save!
  	end
  	email
  end
end
