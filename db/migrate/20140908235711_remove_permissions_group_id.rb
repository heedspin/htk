class RemovePermissionsGroupId < ActiveRecord::Migration
  def change
  	remove_column :permissions, :group_id
  end
end
