class CreateDeliverablePermissions < ActiveRecord::Migration
  def change
  	create_table :permissions do |t|
  		t.references :deliverable
  		t.references :user
  		t.references :group
  		t.boolean :responsible
  		t.references :access
      t.timestamps
  	end
  end
end
