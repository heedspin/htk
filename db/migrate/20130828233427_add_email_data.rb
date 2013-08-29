class AddEmailData < ActiveRecord::Migration
  def change
  	add_column :emails, :data, :text
  end
end
