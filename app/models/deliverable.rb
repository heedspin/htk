# == Schema Information
#
# Table name: deliverables
#
#  id                    :integer          not null, primary key
#  title                 :string(255)
#  parent_deliverable_id :integer
#  status_id             :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Deliverable < ApplicationModel
	belongs_to :parent_deliverable, :class_name => 'Deliverable'
  belongs_to_active_hash :status, :class_name => 'DeliverableStatus'
  has_many :deliverable_users, dependent: :destroy
  has_many :users, through: :deliverable_users
  attr_accessible :title, :status, :status_id, :parent_deliverable_id
  has_many :deliverable_messages, dependent: :destroy
  has_many :messages, through: :deliverable_messages

  scope :not_deleted, where(['status_id != ?', DeliverableStatus.deleted])

end
