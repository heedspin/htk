# == Schema Information
#
# Table name: party_users
#
#  id            :integer          not null, primary key
#  status_id     :integer
#  party_id      :integer
#  user_id       :integer
#  party_role_id :integer
#  created_at    :datetime
#

class PartyUser < ApplicationModel
	belongs_to_active_hash :status, :class_name => 'LifeStatus'
	belongs_to_active_hash :role, class_name: 'PartyRole', foreign_key: :party_role_id
	belongs_to :party
	belongs_to :user
	attr_accessible :status, :user, :party, :role
end
