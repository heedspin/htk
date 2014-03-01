class CreateMessages < ActiveRecord::Migration
  def change
  	create_table :messages do |t|
      t.references :status
  		t.references :message_thread
  		t.string :envelope_message_id
  		t.references :source_email
  		t.datetime :created_at
  	end
  end
end
