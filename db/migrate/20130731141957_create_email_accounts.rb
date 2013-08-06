class CreateEmailAccounts < ActiveRecord::Migration
  def change
    create_table :email_accounts do |t|
      t.references :status
    	t.belongs_to :user
      t.string :username, unique: true
      t.string :authentication_string
      t.string :server
      t.integer :port
      t.string :last_uid
      t.timestamps
    end
    add_index :email_accounts, :username, unique: true
  end
end
