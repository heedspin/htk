class AddDeliverableMessageIsRelated < ActiveRecord::Migration
  def change
  	add_column :deliverable_messages, :is_related, :boolean, default: true
  end
end
