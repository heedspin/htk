# == Schema Information
#
# Table name: message_threads
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class MessageThread < ApplicationModel
	has_many :email_account_threads, dependent: :destroy
	has_many :messages, dependent: :destroy
	has_many :deliverable_relations, dependent: :destroy
	has_many :deliverables, through: :deliverable_relations, source: :target_deliverable

	def self.accessible_to(user)
    user_id = user.is_a?(User) ? user.id : user
    joins(:email_account_threads => :email_account).where(email_accounts: { user_id: user_id })
	end
end
