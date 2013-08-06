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
	def to_s
		"#{name}:#{id}"
	end

	def self.user(user, party_role)
		user_id = user.is_a?(User) ? user.id : user
		joins(:party_users).where(party_users: { user_id: user_id, party_role_id: party_role.same_or_better })
	end
end
