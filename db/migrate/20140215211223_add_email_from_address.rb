class AddEmailFromAddress < ActiveRecord::Migration
  def change
  	add_column :emails, :from_address, :string
  end
end
