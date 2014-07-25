ActiveAdmin.register DeliverableType do
	index do
		column :name
		column :description
		default_actions
	end

	form do |f|
		f.inputs "Details" do
			f.input :name
			f.input :description
			f.input :deliverable_type_config_id#, as: :select, collection: DeliverableTypeConfig.all
		end
		f.actions
	end
end