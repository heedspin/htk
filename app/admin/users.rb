ActiveAdmin.register User do
	filter :email
	index do
		column :email
		column :sign_in_count
		column :current_sign_in_at
		column :last_sign_in_at
		column :current_sign_in_ip
		column :last_sign_in_ip
		default_actions
	end
  form do |f|
		f.inputs do
			f.input :email
		end
		f.inputs do
	    f.has_many :email_accounts, :allow_destroy => true do |eaf|
	  		eaf.input :username
	  		eaf.input :authentication_string
	  		eaf.input :server
	  		eaf.input :port
	    end
	    f.actions
	  end
  end  
	show do |ad|
    attributes_table do
      row :email
      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
    end
    div do
    	user.email_accounts.map do |email_account|
    		p do
    			[email_account.username, email_account.server].join(', ')
    		end
    	end
    end
  end
end
