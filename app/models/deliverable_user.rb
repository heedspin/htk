# == Schema Information
#
# Table name: deliverable_users
#
#  id             :integer          not null, primary key
#  deliverable_id :integer
#  user_id        :integer
#  responsible    :boolean
#  access_id      :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class DeliverableUser < ApplicationModel
	belongs_to :deliverable
	belongs_to :user
  belongs_to_active_hash :access, :class_name => 'DeliverableAccess'
  attr_accessible :user_id, :access_id, :responsible
  def significant?
  	self.access.try(:owner?) || self.responsible
  end

  protected

	 	before_save :ensure_read_access
	 	def ensure_read_access
	 		# To remove read access, you should delete the record or create a noaccess access value.
	 		self.access_id ||= DeliverableAccess.read.id
	 	end
end
