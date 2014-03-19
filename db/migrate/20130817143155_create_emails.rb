class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
    	t.belongs_to :email_account
  		t.string :thread_id
      t.string :folder
      t.datetime :date
  		t.integer :uid
      t.string :guid
      t.string :subject
      t.text :encoded_mail
  		t.datetime :created_at
    end
  end
end
