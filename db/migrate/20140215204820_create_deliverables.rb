class CreateDeliverables < ActiveRecord::Migration
  def change
  	create_table :deliverables do |t|
  		t.string :title
      t.timestamps
  	end

  	create_table :deliverable_messages do |t|
  		t.references :deliverable
  		t.references :message
      t.timestamps
  	end
  end
end
