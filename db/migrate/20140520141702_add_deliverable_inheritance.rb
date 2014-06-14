class AddDeliverableInheritance < ActiveRecord::Migration
  def up
		remove_column :deliverables, :deliverable_type_id
  	add_column :deliverables, :type, :string
  	add_column :deliverables, :data, :text
	end

	def down
  	remove_column :deliverables, :type
  	remove_column :deliverables, :data
		add_column :deliverables, :deliverable_type_id, :integer
	end
end
