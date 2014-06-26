class AddDeliverableCompletedById < ActiveRecord::Migration
  def change
  	add_column :deliverables, :completed_by_id, :integer
  end
end
