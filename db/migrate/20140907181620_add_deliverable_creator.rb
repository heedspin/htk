class AddDeliverableCreator < ActiveRecord::Migration
  def change
  	add_column :deliverables, :creator_id, :integer
  end
end
