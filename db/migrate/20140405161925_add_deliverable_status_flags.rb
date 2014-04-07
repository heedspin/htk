class AddDeliverableStatusFlags < ActiveRecord::Migration
  def change
  	add_column :deliverables, :deleted_by_id, :integer
  	add_column :deliverables, :completed_by_id, :integer
  end
end
