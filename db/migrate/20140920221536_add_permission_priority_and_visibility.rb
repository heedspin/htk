class AddPermissionPriorityAndVisibility < ActiveRecord::Migration
  def change
  	add_column :permissions, :visibility_id, :integer
  	add_column :permissions, :priority_id, :integer
  end
end
