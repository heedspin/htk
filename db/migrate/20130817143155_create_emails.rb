class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
    	t.belongs_to :email_account
      t.belongs_to :message
      t.belongs_to :email_account_thread
  		t.string :thread_id
      t.string :web_id
      t.string :folder
      t.datetime :date
  		t.integer :uid
      t.string :guid
      t.string :from_address
      t.string :subject
      t.text :encoded_mail
      t.text :data
  		t.datetime :created_at
    end
  end
end
