# == Schema Information
#
# Table name: email_account_threads
#
#  id                :integer          not null, primary key
#  email_account_id  :integer
#  message_thread_id :integer
#  thread_id         :string(255)
#  subject           :string(255)
#  start_time        :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class EmailAccountThread < ApplicationModel
	belongs_to :message_thread
	belongs_to :email_account
	attr_accessible :subject, :start_time, :email_account, :message_thread, :thread_id
	has_many :emails, dependent: :destroy

	def self.email_account(email_account)
		where :email_account_id => email_account.id
	end
	def self.subject(txt)
		where :subject => txt
	end
end
