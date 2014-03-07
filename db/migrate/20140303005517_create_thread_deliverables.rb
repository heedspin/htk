class CreateThreadDeliverables < ActiveRecord::Migration
  def change
  	create_table :thread_deliverables do |t|
  		t.references :message_thread
  		t.references :deliverable
  		t.datetime :created_at
  	end
  end
end
