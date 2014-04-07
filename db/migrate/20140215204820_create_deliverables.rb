class CreateDeliverables < ActiveRecord::Migration
  def change
  	create_table :deliverables do |t|
  		t.string :title
  		t.integer :parent_deliverable_id
      t.timestamps
  	end

  	create_table :deliverable_users do |t|
  		t.references :deliverable
  		t.references :user
  		t.boolean :responsible
  		t.references :access
      t.timestamps
  	end

  	create_table :deliverable_messages do |t|
  		t.references :deliverable
  		t.references :message
      t.timestamps
  	end
  end
end
