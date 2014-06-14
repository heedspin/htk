class AddDeliverableTypeConfig < ActiveRecord::Migration
  def up
  	add_column :deliverable_types, :deliverable_type_config_id, :integer
  	remove_column :deliverable_types, :key
  end

  def down
  	remove_column :deliverable_types, :deliverable_type_config_id
  	add_column :deliverable_types, :key, :string
  end
end
