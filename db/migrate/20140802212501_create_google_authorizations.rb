class CreateGoogleAuthorizations < ActiveRecord::Migration
  def change
  	create_table :google_authorizations do |t|
  		t.references :user
      t.string :gplus_id
  		t.string :refresh_token
  		t.string :access_token
  		t.integer :expires_in
  		t.datetime :issued_at
  		t.timestamps
	  end
  end
end
