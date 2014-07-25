class CreateUserGroups < ActiveRecord::Migration
  def change
  	create_table :user_groups do |t|
  		t.string :name
  		t.text :data
  		t.timestamps
  	end

  	add_column :users, :user_group_id, :integer
  end
end
