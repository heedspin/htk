# == Schema Information
#
# Table name: deliverable_comments
#
#  id              :integer          not null, primary key
#  deliverable_id  :integer
#  comment_type_id :integer
#  note            :text
#  created_at      :datetime
#  creator_id      :integer
#

require 'htk_current_user'

class DeliverableComment < ApplicationModel
	belongs_to :deliverable
	belongs_to_active_hash :comment_type, :class_name => 'DeliverableCommentType'
	belongs_to :creator, class_name: 'User', foreign_key: :creator_id
	attr_accessible :comment_type_id, :note, :comment_type, :user

	attr_accessor :user # to set for the update_completion_status

	def self.json_root
		'comment'
	end

	protected
		after_create :update_completion_status
		def update_completion_status
			if self.comment_type.complete?
				self.deliverable.update_attributes(completed_by_id: self.user.try(:id) || HtkCurrentUser.user.id)
			elsif self.comment_type.incomplete?
				self.deliverable.update_attributes(completed_by_id: nil)
			end
		end
end
