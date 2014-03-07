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
  # has_many :deliverable_messages, dependent: :destroy
  # has_many :messages, through: :deliverable_messages

  scope :not_deleted, where(['status_id != ?', DeliverableStatus.deleted])

  def self.web_create(args)
  	email = args[:email] || (raise ':email required')
  	current_user = args[:current_user] || (raise ':current_user required')
  	title = args[:title] || (raise ':title required')
  	deliverable = new(:status => DeliverableStatus.published, :title => title)
  	Deliverable.transaction do
  		deliverable.save!
  		email.message.message_thread.deliverables << deliverable
  		User.email_accounts(email.participants).accessible_to(current_user).each do |recipient|
  			access = if recipient.id == current_user.id
  				DeliverableAccess.owner
  			else
  				DeliverableAccess.edit
  			end
  			deliverable.deliverable_users.create!(user_id: recipient.id, access_id: access.id)
  		end
  	end
  	deliverable
  end
end
