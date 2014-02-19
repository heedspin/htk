class AddEmailWebid < ActiveRecord::Migration
  def change
  	add_column :emails, :web_id, :string
  end
end
