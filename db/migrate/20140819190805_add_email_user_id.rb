class AddEmailUserId < ActiveRecord::Migration
  def change
  	add_column :emails, :user_id, :integer
  	add_column :emails, :snippet, :string
  	add_column :email_account_threads, :user_id, :integer
  end
end
