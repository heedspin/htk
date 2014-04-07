# == Schema Information
#
# Table name: deliverables
#
#  id                    :integer          not null, primary key
#  title                 :string(255)
#  parent_deliverable_id :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  description           :text
#  deleted_by_id         :integer
#  completed_by_id       :integer
#

class Deliverable < ApplicationModel
	belongs_to :parent_deliverable, class_name: 'Deliverable'
  has_many :deliverable_users, dependent: :destroy
  has_many :users, through: :deliverable_users
  attr_accessible :title, :status, :status_id, :parent_deliverable_id, :description
  # has_many :deliverable_messages, dependent: :destroy
  # has_many :messages, through: :deliverable_messages
  belongs_to :deleted_by, class_name: 'User', foreign_key: :deleted_by_id
  belongs_to :completed_by, class_name: 'User', foreign_key: :completed_by_id
  has_many :comments, class_name: 'DeliverableComment', dependent: :destroy

  scope :not_deleted, where('deleted_by_id is null')

  def self.web_create(args)
  	email = args[:email] || (raise ':email required')
  	current_user = args[:current_user] || (raise ':current_user required')
  	title = args[:title] || (raise ':title required')
  	deliverable = new(title: title, description: args[:description])
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
  def self.editable_by(user)
    user_id = user.is_a?(User) ? user.id : user
    includes(:deliverable_users).where(deliverable_users: { user_id: user_id, access_id: [DeliverableAccess.owner.id, DeliverableAccess.edit.id] })
  end
end
