class AddDeliverableStatusFlag < ActiveRecord::Migration
  def change
  	add_column :deliverables, :status_id, :integer
  end
end
