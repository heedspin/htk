# == Schema Information
#
# Table name: deliverables
#
#  id              :integer          not null, primary key
#  title           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  description     :text
#  type            :string(255)
#  data            :text
#  abbreviation    :string(255)
#  completed_by_id :integer
#  status_id       :integer
#

require 'plutolib/serialized_attributes'
require 'exceptions/access_denied'

class Deliverable < ApplicationModel
  include Plutolib::SerializedAttributes
  has_many :permissions, dependent: :destroy
  has_many :users, through: :permissions
  attr_accessible :title, :status, :status_id, :description, :completed_by_id
  # has_many :deliverable_messages, dependent: :destroy
  # has_many :messages, through: :deliverable_messages
  belongs_to :completed_by, class_name: 'User', foreign_key: :completed_by_id
  has_many :comments, class_name: 'DeliverableComment', dependent: :destroy
  has_many :source_relations, class_name: 'DeliverableRelation', foreign_key: :source_deliverable_id, dependent: :destroy
  has_many :target_relations, class_name: 'DeliverableRelation', foreign_key: :target_deliverable_id, dependent: :destroy
  has_many :children_relations, class_name: 'DeliverableRelation', foreign_key: :target_deliverable_id
  has_many :children, class_name: 'Deliverable', through: :children_relations, source: 'source_deliverable'
  has_many :parent_relations, class_name: 'DeliverableRelation', foreign_key: :target_deliverable_id, conditions: { relation_type_id: DeliverableRelationType.parent.id }
  belongs_to_active_hash :status, :class_name => 'LifeStatus'
  # belongs_to :deliverable_type
  # validates :deliverable_type_id, presence: true
  validates :title, presence: true

  def deliverable_type
    self.deliverable_type_config.first.deliverable_type
  end

  def deliverable_type_config
    DeliverableTypeConfig.where(ar_type: self.class.name)
  end

  def significant_permissions
    self.permissions.all.select(&:significant?)
  end

  scope :not_deleted, where(['deliverables.status_id != ?', LifeStatus.deleted.id])
  scope :by_created_at_desc, order('deliverables.created_at desc')

  def self.accessible_to(user)
    user_id = user.is_a?(User) ? user.id : user
    includes(:permissions).where(permissions: { user_id: user_id, access_id: DeliverableAccess.all.map(&:id) })
  end
  def self.title_like(text)
    where ['deliverables.title ilike ?', "%#{text}%"]
  end
  def self.excluding(deliverable_ids)
    where ['deliverables.id not in (?)', deliverable_ids]
  end
  def self.user_group(group)
    group_id = group.is_a?(UserGroup) ? group.id : group
    includes(:permissions).where(permissions: { group_id: group_id })
  end
  def self.responsible_user(user)
    user_id = user.is_a?(User) ? user.id : user
    includes(:permissions).where(permissions: { user_id: user_id, responsible: true})
  end
  def self.type(type_config_id)
    where type: DeliverableTypeConfig.find(type_config_id).ar_type
  end
  def self.editable_by(user)
    user_id = user.is_a?(User) ? user.id : user
    includes(:permissions).where(permissions: { user_id: user_id, access_id: [DeliverableAccess.owner.id, DeliverableAccess.edit.id] })
  end

  def folder_name(use_previous_name=false)
    if use_previous_name
      self.abbreviation_was.present? ? self.abbreviation_was : self.title_was
    else
      self.abbreviation.present? ? self.abbreviation : self.title
    end
  end

  def destroy
    self.status_id = LifeStatus.deleted.id
    self.target_relations.each(&:destroy)
    self.source_relations.each(&:destroy)
    # self.permissions.each(&:destroy)
    if self.is_assigned?
      TodoFolder.new(self).delay.remove
    end
    self.save!
  end

  def complete?
    self.completed_by_id.present?
  end
  def incomplete?
    self.completed_by_id.nil?
  end
  def is_assigned?
    (self.permissions.responsible.count > 0)
  end

  def has_behavior?(key)
    self.deliverable_type.has_behavior?(key)
  end

  before_update :update_folders
  def update_folders
    if self.abbreviation_changed? or (self.abbreviation.blank? and self.title_changed?)
      self.target_relations.top_level.each do |relation| 
        group_config = self.users.first.preferences # TODO: fix me?
        from_deliverable_path = group_config.deliverable_folder_path(self, { folder_name: self.folder_name(true) })
        relation.rename_folder_from(from_deliverable_path)
      end
    end
    if self.is_assigned? and self.completed_by_id_changed?
      if self.complete?
        TodoFolder.new(self).delay.remove
      else
        TodoFolder.new(self).delay.create
      end
    end
  end

  def self.ensure_editable_by!(deliverable_ids, user)
    deliverable_ids = deliverable_ids.is_a?(Array) ? deliverable_ids : [deliverable_ids]
    deliverable_ids.each do |deliverable_id|
      access_ids = Permission.deliverable_id(deliverable_id).all.map(&:access_id)
      intersection = [DeliverableAccess.owner.id, DeliverableAccess.edit.id] & access_id
      if intersection.size == 0
        raise Exception::AccessDenied
      end
    end
    deliverable_ids
  end
  def ensure_editable_by!(user)
    unless [DeliverableAccess.owner.id, DeliverableAccess.edit.id].include?(self.permissions.user(user).first.access_id)    
      raise Exception::AccessDenied
    end
    self
  end

end
