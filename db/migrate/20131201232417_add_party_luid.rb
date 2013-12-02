class AddPartyLuid < ActiveRecord::Migration
  def change
  	add_column :parties, :luid, :string
  end
end
