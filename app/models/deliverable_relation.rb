# == Schema Information
#
# Table name: deliverable_relations
#
#  id                    :integer          not null, primary key
#  status_id             :integer
#  integer               :integer
#  source_deliverable_id :integer
#  target_deliverable_id :integer
#  relation_type_id      :integer
#  message_thread_id     :integer
#  previous_sibling_id   :integer
#  message_id            :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class DeliverableRelation < ApplicationModel
  belongs_to_active_hash :relation_type, :class_name => 'DeliverableRelationType'
	belongs_to :source_deliverable, class_name: 'Deliverable', foreign_key: :source_deliverable_id
	belongs_to :target_deliverable, class_name: 'Deliverable', foreign_key: :target_deliverable_id
  attr_accessible :source_deliverable_id, :target_deliverable_id, :relation_type_id, :previous_sibling_id, :message_thread_id, :message_id, :status_id
  belongs_to :previous_sibling, class_name: 'DeliverableRelation', foreign_key: :previous_sibling_id
  belongs_to :message_thread
  belongs_to :message
  belongs_to_active_hash :status, :class_name => 'LifeStatus'

  def self.deliverables(deliverables)
    ids = deliverables.map(&:id)
    where ['deliverable_relations.source_deliverable_id in (?) or deliverable_relations.target_deliverable_id in (?)', ids, ids]
  end

  # This does not work if source_deliverable_id is null (no parent).
  # def self.editable_by(user)
  #   user_id = user.is_a?(User) ? user.id : user
  #   access_ids = [DeliverableAccess.owner.id, DeliverableAccess.edit.id]
  #   includes(:source_deliverable => :deliverable_users).includes(:target_deliverable => :deliverable_users).where(['deliverable_users.user_id = ? and deliverable_users.access_id in (?)', user_id, access_ids])
  # end

  scope :not_deleted, where(['deliverable_relations.status_id != ?', LifeStatus.deleted.id])
  def self.message_thread_id(mti)
    where :message_thread_id => mti
  end
  def self.top_level
    where relation_type_id: DeliverableRelationType.parent.id, source_deliverable_id: nil
  end
  scope :by_date, order(:created_at)
  scope :tree, where(relation_type_id: DeliverableRelationType.parent.id)

  def is_top_level
    DeliverableRelation.is_top_level(self.relation_type_id, self.source_deliverable_id)
  end
  def self.is_top_level(relation_type_id, source_deliverable_id)
    DeliverableRelationType.find(relation_type_id).try(:parent?) && source_deliverable_id.nil?
  end

  after_create :copy_to_folders
  def copy_to_folders
    if self.is_top_level
      DeliverableFolder.new(self).delay.copy_all_to_folder
    end
  end

  before_update :update_folders
  def update_folders
    if self.relation_type_id_changed? or self.source_deliverable_id_changed?
      was_tl = DeliverableRelation.is_top_level(self.relation_type_id_was, self.source_deliverable_id_was)
      is_tl = self.is_top_level
      if was_tl and !is_tl
        self.remove_all_from_folder
      elsif !was_tl and is_tl
        self.copy_to_folders
      end
    end
  end

  def remove_all_from_folder
    DeliverableFolder.new(self).delay.remove_all_from_folder
  end

  def rename_folder_from(from_deliverable_path)
    if self.is_top_level
      DeliverableFolder.new(self).delay.rename_folder(from_deliverable_path)
    end
  end

  def destroy
    self.status_id = LifeStatus.deleted.id
    self.save!
    if self.is_top_level
      self.remove_all_from_folder
    end
  end
end
