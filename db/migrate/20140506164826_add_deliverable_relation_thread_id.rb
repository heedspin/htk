class AddDeliverableRelationThreadId < ActiveRecord::Migration
  def change
  	add_column :deliverable_relations, :message_thread_id, :integer
  end
end
