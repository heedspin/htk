# == Schema Information
#
# Table name: deliverables
#
#  id              :integer          not null, primary key
#  title           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  description     :text
#  deleted_by_id   :integer
#  completed_by_id :integer
#  type            :string(255)
#  data            :text
#  abbreviation    :string(255)
#

require 'plutolib/serialized_attributes'

class Deliverable < ApplicationModel
  include Plutolib::SerializedAttributes
  has_many :deliverable_users, dependent: :destroy
  has_many :users, through: :deliverable_users
  attr_accessible :title, :status, :status_id, :description, :completed_by_id
  # has_many :deliverable_messages, dependent: :destroy
  # has_many :messages, through: :deliverable_messages
  belongs_to :deleted_by, class_name: 'User', foreign_key: :deleted_by_id
  belongs_to :completed_by, class_name: 'User', foreign_key: :completed_by_id
  has_many :comments, class_name: 'DeliverableComment', dependent: :destroy
  has_many :source_relations, class_name: 'DeliverableRelation', foreign_key: :source_deliverable_id, dependent: :destroy
  has_many :target_relations, class_name: 'DeliverableRelation', foreign_key: :target_deliverable_id, dependent: :destroy
  has_many :children_relations, class_name: 'DeliverableRelation', foreign_key: :target_deliverable_id
  has_many :children, class_name: 'Deliverable', through: :children_relations, source: 'source_deliverable'
  has_many :parent_relations, class_name: 'DeliverableRelation', foreign_key: :target_deliverable_id, conditions: { relation_type_id: DeliverableRelationType.parent.id }
  # belongs_to :deliverable_type
  # validates :deliverable_type_id, presence: true
  validates :title, presence: true

  def deliverable_type
    DeliverableTypeConfig.where(ar_type: self.class.name).first.deliverable_type
  end

  def significant_users
    self.deliverable_users.all.select(&:significant?)
  end

  scope :not_deleted, where(deleted_by_id: nil)
  scope :by_created_at_desc, order('deliverables.created_at desc')

  def self.web_create(args)
  	email = args[:email] || (raise ':email required')
  	current_user = args[:current_user] || (raise ':current_user required')
    params = args[:params]
    deliverable_type = if config_id = params[:config_id]
      DeliverableTypeConfig.find(config_id).ar_type_class
    else
      DeliverableTypeConfig.standard.ar_type_class
    end
  	deliverable = deliverable_type.new
    accessible_attributes = deliverable_type.accessible_attributes.select(&:present?)
    deliverable.update_attributes(params.select { |k,v| accessible_attributes.include?(k) })
    # id = args[:id]
    # deliverable.id = id if id.present?
  	Deliverable.transaction do
  		deliverable.save!
  		# email.message.message_thread.deliverables << deliverable
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
  def self.accessible_to(user)
    user_id = user.is_a?(User) ? user.id : user
    includes(:deliverable_users).where(deliverable_users: { user_id: user_id, access_id: DeliverableAccess.all.map(&:id) })
  end
  def self.title_like(text)
    where ['deliverables.title ilike ?', "%#{text}%"]
  end
  def self.excluding(deliverable_ids)
    where ['deliverables.id not in (?)', deliverable_ids]
  end

  def folder_name
    self.abbreviation.present? ? self.abbreviation : self.title
  end
end
