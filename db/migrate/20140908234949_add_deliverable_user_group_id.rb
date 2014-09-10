class AddDeliverableUserGroupId < ActiveRecord::Migration
  def change
  	add_column :deliverables, :user_group_id, :integer
  end
end
