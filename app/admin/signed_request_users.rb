ActiveAdmin.register SignedRequestUser do
	belongs_to :user
	# navigation_menu :user
	# filter :user
	index do
		column :user
	  column :opensocial_container
	  column :original_opensocial_app_url
		default_actions
	end
end
