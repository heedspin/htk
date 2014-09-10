class AddMessageUserGroupId < ActiveRecord::Migration
  def change
  	add_column :messages, :user_group_id, :integer
  end
end
