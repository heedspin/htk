ActiveAdmin.register EmailAccount do
	belongs_to :user
	navigation_menu :user
	# belongs_to :email_account_status
	filter :user
	filter :server
	index do
		column :user
	  column :username
	  column :authentication_string
	  column :server
	  column :port
	end
  form do |f|
  	f.inputs do 
  		f.input :username
  		f.input :authentication_string
  		f.input :status_id
  		f.input :server
  		f.input :port
  	end
	  f.actions
  end
	# show do |ad|
 #    attributes_table do
 #      row :username
 #    end
 #  end
end
