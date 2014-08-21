class CreateGmailSynchronizations < ActiveRecord::Migration
  def change
  	create_table :gmail_synchronizations do |t|
  		t.references :user
  		t.datetime :last_sync
  		t.integer :last_history_id, limit: 8
  		t.timestamps
  	end
  end
end
