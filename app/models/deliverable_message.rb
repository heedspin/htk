# == Schema Information
#
# Table name: deliverable_messages
#
#  id             :integer          not null, primary key
#  deliverable_id :integer
#  message_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class DeliverableMessage < ApplicationModel
	belongs_to :deliverable
	belongs_to :message
end
