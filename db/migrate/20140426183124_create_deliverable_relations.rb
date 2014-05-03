class CreateDeliverableRelations < ActiveRecord::Migration
  def up
  	remove_column :deliverables, :parent_deliverable_id
  	create_table :deliverable_relations do |t|
  		t.integer :source_deliverable_id
  		t.integer :target_deliverable_id
  		t.integer :relation_type_id
  		t.timestamps
  	end
  end

  def down
  	add_column :deliverables, :parent_deliverable_id, :integer
  	drop_table :deliverable_relations
  end
end
