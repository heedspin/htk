class AddDeliverableTypeGroupId < ActiveRecord::Migration
  def change
  	add_column :deliverable_types, :user_group_id, :integer
  end
end
