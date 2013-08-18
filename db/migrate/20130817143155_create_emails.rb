class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
    	t.belongs_to :email_account
  		t.string :conversation_id
      t.string :folder
      t.datetime :date
  		t.string :uid
      t.string :guid
      t.string :subject
      t.text :encoded_mail
  		t.datetime :created_at
    end
  end
end
