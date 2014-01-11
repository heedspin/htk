class CreateComments < ActiveRecord::Migration
  def change
  	create_table :email_comments do |t|
  		t.references :status
  		t.references :user
  		t.string :email_message_id
  		t.string :email_subject
  		t.string :email_send_time
  		t.string :sender_email
  		t.references :format
  		t.text :comment
  	end

  	create_table :email_comment_users do |t|
  		t.references :email_comment
  		t.references :user
  	end
  end
end
