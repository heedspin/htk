class CreateDeliverables < ActiveRecord::Migration
  def change
  	create_table :deliverables do |t|
  		t.string :title
      t.timestamps
  	end
  end
end
