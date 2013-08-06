class CreateParties < ActiveRecord::Migration
  def change
  	create_table :parties do |t|
      t.references :status
  		t.string :name
  		t.text :description
  		t.integer :creator_id

  		t.timestamps
  	end

  	create_table :party_users do |t|
      t.references :status
  		t.references :party
  		t.references :user
  		t.references :party_role
      t.datetime :created_at
  	end

  	create_table :conversations do |t|
      t.references :status
  		t.references :party
      t.datetime :created_at
  	end

  	create_table :email_account_conversations do |t|
      t.references :status
      t.references :party
  		t.references :conversation
  		t.references :email_account
  		t.string :email_conversation_id
  		t.datetime :created_at
  	end

  	create_table :messages do |t|
      t.references :status
  		t.references :conversation
  		t.datetime :date
      t.text :data
  		t.string :envelope_message_id
      t.string :identity_hash
      t.string :body_boundary
  		t.text :encoded_body
      t.string :subject, limit: 1000
  		t.datetime :created_at
  	end

  	create_table :email_receipts do |t|
      t.references :status
  		t.references :email_account_conversation
  		t.references :message
      t.string :email_folder
  		t.string :email_uid
      t.string :email_guid
      t.text :encoded_header
  		t.datetime :created_at
  	end

    create_table :conversation_imports do |t|
      t.references :status
      t.references :email_account_conversation
      t.references :process_pending_imports
      t.references :delayed_job
      t.references :delayed_job_status
      t.text :delayed_job_log
      t.string :delayed_job_method
      t.references :user
      t.timestamps
    end
  end
end
