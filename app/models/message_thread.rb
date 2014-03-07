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
	has_many :thread_deliverables, dependent: :destroy
	has_many :deliverables, through: :thread_deliverables
end
