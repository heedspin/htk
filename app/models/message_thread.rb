# == Schema Information
#
# Table name: message_threads
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status_id  :integer          default(2)
#

class MessageThread < ApplicationModel
	has_many :email_account_threads, dependent: :destroy
	has_many :messages, dependent: :destroy
	has_many :deliverable_relations, dependent: :destroy
	has_many :deliverables, through: :deliverable_relations, source: :target_deliverable
	belongs_to_active_hash :status, :class_name => 'LifeStatus'

	def self.accessible_to(user)
    user_id = user.is_a?(User) ? user.id : user
    joins(:email_account_threads => :email_account).where(email_accounts: { user_id: user_id })
	end
  scope :not_deleted, where(['message_threads.status_id != ?', LifeStatus.deleted.id])

  def destroy
  	self.status = LifeStatus.deleted
  	self.email_account_threads.each(&:destroy)
  	self.messages.each(&:destroy)
  	self.deliverable_relations.each(&:destroy)
  	self.save!
  end
end
