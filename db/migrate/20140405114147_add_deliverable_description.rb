class AddDeliverableDescription < ActiveRecord::Migration
  def change
  	add_column :deliverables, :description, :text
  end
end
