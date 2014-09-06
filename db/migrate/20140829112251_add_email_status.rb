class AddEmailStatus < ActiveRecord::Migration
  def change
  	change_column :messages, :status_id, :integer, default: 2
  	add_column :message_threads, :status_id, :integer, default: 2
  	add_column :emails, :status_id, :integer, default: 2
  	add_column :email_account_threads, :status_id, :integer, default: 2
  end
end
