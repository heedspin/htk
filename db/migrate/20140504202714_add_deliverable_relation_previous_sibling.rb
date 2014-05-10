class AddDeliverableRelationPreviousSibling < ActiveRecord::Migration
  def change
  	add_column :deliverable_relations, :previous_sibling_id, :integer
  end
end
