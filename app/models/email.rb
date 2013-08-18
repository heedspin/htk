# == Schema Information
#
# Table name: emails
#
#  id               :integer          not null, primary key
#  email_account_id :integer
#  conversation_id  :string(255)
#  folder           :string(255)
#  date             :datetime
#  uid              :string(255)
#  guid             :string(255)
#  subject          :string(255)
#  encoded_mail     :text
#  created_at       :datetime
#

require 'htk_imap/mail_utils'

class Email < ApplicationModel
	include HtkImap::MailUtils
	attr_accessible :folder, :date, :uid, :guid, :subject, :mail, :conversation_id
	belongs_to :email_account
	scope :by_uid, order(:uid)
	scope :uid_desc, order('emails.uid desc')

	def self.user(user)
		user_id = user.is_a?(User) ? user.id : user
		joins(:email_account).where(email_account: { user_id: user_id })
	end
	def self.starting_uid(uid)
		where(['emails.uid < ?', uid])
	end

	attr_accessor :mail
	def mail=(m)
		strip_attachments(m)
		self.encoded_mail = m.encoded
		@mail = m
	end
	def mail
		@mail ||= Mail.new(self.encoded_mail)
	end

end
