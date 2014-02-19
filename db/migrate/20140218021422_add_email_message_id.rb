class AddEmailMessageId < ActiveRecord::Migration
  def change
  	add_column :emails, :message_id, :integer
  end
end
