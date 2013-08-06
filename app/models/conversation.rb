# == Schema Information
#
# Table name: conversations
#
#  id         :integer          not null, primary key
#  status_id  :integer
#  party_id   :integer
#  created_at :datetime
#

class Conversation < ApplicationModel
	attr_accessible :status, :party
	belongs_to_active_hash :status, :class_name => 'LifeStatus'
	belongs_to :party
	has_many :messages
	has_many :email_account_conversations, :dependent => :destroy
	has_many :email_accounts, :through => :email_account_conversations
end
