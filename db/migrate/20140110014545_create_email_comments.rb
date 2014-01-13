class CreateEmailComments < ActiveRecord::Migration
  def change
  	create_table :email_comments do |t|
  		t.references :status
  		t.string :email_message_id
  		t.string :email_subject
  		t.string :email_send_time
  		t.string :email_sender
  		t.references :format
  		t.text :comment
      t.timestamps
  	end

  	create_table :email_comment_users do |t|
  		t.references :email_comment
      t.references :role
  		t.references :user
  	end
  end
end
