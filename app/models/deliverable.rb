# == Schema Information
#
# Table name: deliverables
#
#  id              :integer          not null, primary key
#  title           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  description     :text
#  completed_by_id :integer
#  type            :string(255)
#  data            :text
#  abbreviation    :string(255)
#  status_id       :integer
#  creator_id      :integer
#  user_group_id   :integer
#

require 'plutolib/serialized_attributes'
require 'exceptions/access_denied'
require 'belongs_to_user_group'

class Deliverable < ApplicationModel
  include BelongsToUserGroup
  include Plutolib::SerializedAttributes
  has_many :permissions, dependent: :destroy
  has_many :users, through: :permissions
  attr_accessible :title, :status, :status_id, :description, :completed_by_id
  belongs_to :completed_by, class_name: 'User', foreign_key: :completed_by_id
  belongs_to :creator, class_name: 'User', foreign_key: :creator_id
  has_many :comments, class_name: 'DeliverableComment', dependent: :destroy
  has_many :source_relations, class_name: 'DeliverableRelation', foreign_key: :source_deliverable_id, dependent: :destroy
  has_many :target_relations, class_name: 'DeliverableRelation', foreign_key: :target_deliverable_id, dependent: :destroy
  has_many :parent_relations, class_name: 'DeliverableRelation', foreign_key: :target_deliverable_id, conditions: { relation_type_id: DeliverableRelationType.parent.id }
  belongs_to_active_hash :status, :class_name => 'LifeStatus'
  # belongs_to :deliverable_type
  # validates :deliverable_type_id, presence: true
  validates :title, presence: true

  def deliverable_type
    self.deliverable_type_config.deliverable_type(self.user_group_id)
  end

  def deliverable_type_config
    DeliverableTypeConfig.where(ar_type: self.class.name).first
  end

  scope :not_deleted, where(['deliverables.status_id != ?', LifeStatus.deleted.id])
  scope :by_created_at_desc, order('deliverables.created_at desc')

  def self.accessible_to(user)
    user_id = user.is_a?(User) ? user.id : user
    includes(:permissions).merge(Permission.user_or_group(user))
  end
  def self.title_like(text)
    where ['deliverables.title ilike ?', "%#{text}%"]
  end
  def self.excluding(deliverable_ids)
    where ['deliverables.id not in (?)', deliverable_ids]
  end
  def self.responsible_user(user)
    user_id = user.is_a?(User) ? user.id : user
    includes(:permissions).where(permissions: { user_id: user_id, responsible: true})
  end
  def self.creator(user)
    user_id = user.is_a?(User) ? user.id : user
    where(creator_id: user_id)
  end
  def self.created_after(time)
    time = time.is_a?(String) ? DateTime.parse(time) : time
    where ['deliverables.created_at > ?', time]
  end
  def self.deliverable_type(deliverable_type)
    deliverable_type = deliverable_type.is_a?(DeliverableType) ? deliverable_type : DeliverableType.find(deliverable_type)
    where type: DeliverableTypeConfig.find(deliverable_type.deliverable_type_config_id).ar_type
  end
  def self.deliverable_type_config(type_config_id)
    where type: DeliverableTypeConfig.find(type_config_id).ar_type
  end
  def self.editable_by(user)
    user_id = user.is_a?(User) ? user.id : user
    includes(:permissions).merge(Permission.user_or_group(user).editable)
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
    # if self.is_assigned?
    #   TodoFolder.new(self).delay.remove
    # end
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

  serialized_attribute :source_email_id

  def has_behavior?(key)
    self.deliverable_type.has_behavior?(key)
  end

  # before_update :update_folders
  # def update_folders
  #   if self.abbreviation_changed? or (self.abbreviation.blank? and self.title_changed?)
  #     self.target_relations.top_level.each do |relation| 
  #       group_config = self.users.first.preferences # TODO: fix me?
  #       from_deliverable_path = group_config.deliverable_folder_path(self, { folder_name: self.folder_name(true) })
  #       relation.rename_folder_from(from_deliverable_path)
  #     end
  #   end
  #   if self.is_assigned? and self.completed_by_id_changed?
  #     if self.complete?
  #       TodoFolder.new(self).delay.remove
  #     else
  #       TodoFolder.new(self).delay.create
  #     end
  #   end
  # end

  def self.ensure_editable_by!(deliverable_ids, user)
    deliverable_ids = deliverable_ids.is_a?(Array) ? deliverable_ids : [deliverable_ids]
    deliverable_ids.each do |deliverable_id|
      if Permission.user_or_group(user).deliverable(deliverable_id).editable.count == 0
        raise Exception::AccessDenied
      end
    end
    deliverable_ids
  end
  def ensure_editable_by!(user)
    if self.permissions.user_or_group(user).editable.count == 0
      raise Exception::AccessDenied
    end
    self
  end

end
