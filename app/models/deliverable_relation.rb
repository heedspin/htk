# == Schema Information
#
# Table name: deliverable_relations
#
#  id                    :integer          not null, primary key
#  source_deliverable_id :integer
#  target_deliverable_id :integer
#  relation_type_id      :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  previous_sibling_id   :integer
#  message_thread_id     :integer
#

class DeliverableRelation < ApplicationModel
  belongs_to_active_hash :relation_type, :class_name => 'DeliverableRelationType'
	belongs_to :source_deliverable, class_name: 'Deliverable', foreign_key: :source_deliverable_id
	belongs_to :target_deliverable, class_name: 'Deliverable', foreign_key: :target_deliverable_id
  attr_accessible :source_deliverable_id, :target_deliverable_id, :relation_type_id, :previous_sibling_id, :message_thread_id
  belongs_to :previous_sibling, class_name: 'DeliverableRelation', foreign_key: :previous_sibling_id
  belongs_to :message_thread

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

  def self.message_thread_id(mti)
    where :message_thread_id => mti
  end
  def self.top_level
    where relation_type_id: DeliverableRelationType.parent.id, source_deliverable_id: nil
  end

  after_save :copy_to_folders
  def copy_to_folders
    if (self.relation_type.try(:parent?) and self.source_deliverable_id.nil?)
      CopyToDeliverableFolder.new(self).delay.copy_all_to_folder
    end
  end
end
