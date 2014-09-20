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
#  user_id           :integer
#  status_id         :integer          default(2)
#

class EmailAccountThread < ApplicationModel
	belongs_to :message_thread
	belongs_to :user
	attr_accessible :subject, :start_time, :email_account, :message_thread, :thread_id, :user_id, :status, :status_id
	has_many :emails, dependent: :destroy
	belongs_to_active_hash :status, :class_name => 'LifeStatus'

	def self.email_account(user_id)
		where :user_id => user_id
	end
	def self.subject(txt)
		where :subject => txt
	end
	def self.accessible_to_deliverable(deliverable)
		joins(:email_account).where(email_accounts: { user_id: deliverable.user_ids})
	end
  scope :not_deleted, where(['email_account_threads.status_id != ?', LifeStatus.deleted.id])
  def self.user(user)
  	user_id = user.is_a?(User) ? user.id : user
  	where user_id: user_id
  end

	def resync!
		self.user.gmail_synchronization.resync_thread(self)
	end

	def destroy
		self.status = LifeStatus.deleted
		self.emails.each(&:destroy)
		self.save!
	end
end
