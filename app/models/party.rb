# == Schema Information
#
# Table name: parties
#
#  id          :integer          not null, primary key
#  status_id   :integer
#  name        :string(255)
#  description :text
#  creator_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Party < ApplicationModel
	attr_accessible :name
	belongs_to_active_hash :status, class_name: 'LifeStatus'
	has_many :conversations, dependent: :destroy
	has_many :party_users, dependent: :destroy
	has_many :users, through: :party_users
	validates :name, presence: true
	has_many :messages, through: :conversations
	has_many :email_account_conversations
	def to_s
		"#{name}:#{id}"
	end

	def self.user(user, party_role=PartyRole.read_only)
		user_id = user.is_a?(User) ? user.id : user
		joins(:party_users).where(party_users: { user_id: user_id, party_role_id: party_role.same_or_better })
	end

	def update_import!(args={})
		self.email_account_conversations.each do |eac|
			eac.update_import!(args)
		end
	end

	def self.attach_to_emails(emails)
		emails = [emails] if emails.is_a?(Email)
		ea_conversations = EmailAccountConversation.where(:email_account_id => emails.map(&:email_account_id).uniq).
			where(:thread_id => emails.map(&:thread_id)).
			includes(:party).all
		emails.each do |email|
			ea_conversations.each do |eac|
				if (email.thread_id == eac.thread_id) and (email.email_account_id == eac.email_account_id)
					email.parties.push(eac.party)
				end
			end
		end
		emails
	end
end
