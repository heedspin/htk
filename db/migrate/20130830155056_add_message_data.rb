class AddMessageData < ActiveRecord::Migration
  def change
  	add_column :messages, :data, :text
  end
end
