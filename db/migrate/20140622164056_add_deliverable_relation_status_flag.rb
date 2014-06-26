class AddDeliverableRelationStatusFlag < ActiveRecord::Migration
  def change
  	add_column :deliverable_relations, :status_id, :integer
  end
end
