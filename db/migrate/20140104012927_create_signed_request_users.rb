class CreateSignedRequestUsers < ActiveRecord::Migration
  def change
  	create_table :signed_request_users do |t|
  		t.datetime :created_at
  		t.string :original_opensocial_app_id
  		t.string :original_opensocial_app_url
  		t.string :opensocial_owner_id
  		t.string :opensocial_container
  		t.references :user
  	end
  end
end
