class CreateThreads < ActiveRecord::Migration
  def change
  	create_table :message_threads do |t|
  		t.timestamps
  	end

  	create_table :email_account_threads do |t|
      t.references :email_account
      t.references :message_thread
  		t.string :thread_id
  		t.string :subject
  		t.datetime :start_time
  		t.timestamps
  	end

  	add_column :emails, :email_account_thread_id, :integer
  end
end
