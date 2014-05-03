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
#

class DeliverableRelation < ApplicationModel
  belongs_to_active_hash :relation_type, :class_name => 'DeliverableRelationType'
	belongs_to :source_deliverable, foreign_key: :source_deliverable_id
	belongs_to :target_deliverable, foreign_key: :target_deliverable_id
  attr_accessible :source_deliverable_id, :target_deliverable_id, :relation_type_id

  def self.get_trees(*deliverables)
    # unless deliverables.is_a?(Array)
    #   deliverables = [deliverables]
    # end
    deliverables = deliverables.flatten.map { |d| 
      if d.is_a?(Fixnum)
        Deliverable.find(d)
      else
        d
      end
    }
    all_deliverables = deliverables.map(&:id)
    all_relations = Hash.new
    additional = []
    while true
      relations = DeliverableRelation.where [
      	'deliverable_relations.source_deliverable_id in (?) or deliverable_relations.target_deliverable_id in (?)',
      	all_deliverables, all_deliverables
      ]
      if all_relations.size > 0
        relations = relations.where [ 'deliverable_relations.id not in (?)', all_relations.keys ]
      end
      found_new_relation = false
      relations.each { |r| 
        unless all_relations.member?(r.id)
          found_new_relation = true
          all_relations[r.id] = r 
        end
      }
      new_deliverables = relations.map { |r| [r.source_deliverable_id, r.target_deliverable_id] }.flatten - all_deliverables
      if (new_deliverables.size == 0) and !found_new_relation
        break
      else
        all_deliverables += new_deliverables
        additional += new_deliverables
      end
    end
    if additional.size > 0
    	deliverables += Deliverable.where(['id in (?)', additional.uniq]).all
    end
    [deliverables, all_relations.values]
  end
end
