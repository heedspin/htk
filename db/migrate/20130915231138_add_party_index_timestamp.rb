class AddPartyIndexTimestamp < ActiveRecord::Migration
  def up
  	add_column :parties, :index_timestamp, :datetime
  	execute "update parties set index_timestamp = updated_at"
  end

  def down
  	remove_column :parties, :index_timestamp
  end
end
