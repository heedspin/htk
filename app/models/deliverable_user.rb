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
end
