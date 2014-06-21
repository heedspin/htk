class AddDeliverableAbbreviation < ActiveRecord::Migration
  def change
  	add_column :deliverables, :abbreviation, :string
  end
end
