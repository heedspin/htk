# == Schema Information
#
# Table name: thread_deliverables
#
#  id                :integer          not null, primary key
#  message_thread_id :integer
#  deliverable_id    :integer
#  created_at        :datetime
#

class ThreadDeliverable < ApplicationModel
	belongs_to :message_thread
	belongs_to :deliverable
	attr_accessible :message_thread_id, :deliverable_id
end
