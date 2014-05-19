class AddDeliverableTypes < ActiveRecord::Migration
  def change
  	create_table :deliverable_types do |t|
  		t.string :name
  		t.text :description
  		t.string :key
  		t.timestamps
  	end
  	add_column :deliverables, :deliverable_type_id, :integer
  end
end
