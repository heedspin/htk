class CreateDeliverableComments < ActiveRecord::Migration
  def change
  	create_table :deliverable_comments do |t|
  		t.belongs_to :deliverable
  		t.belongs_to :comment_type
  		t.text :note
  		t.datetime :created_at
  		t.integer :creator_id
  	end
  end
end
