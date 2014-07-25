class CreateDeliverableRelations < ActiveRecord::Migration
  def up
  	create_table :deliverable_relations do |t|
      t.integer :status_id
  		t.integer :source_deliverable_id
  		t.integer :target_deliverable_id
  		t.integer :relation_type_id
      t.integer :message_thread_id
      t.integer :previous_sibling_id
      t.integer :message_id
  		t.timestamps
  	end
  end

  def down
  	drop_table :deliverable_relations
  end
end
