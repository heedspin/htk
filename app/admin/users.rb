ActiveAdmin.register User do
	filter :email
	index do
		column :name
		column :email
		column :sign_in_count
		column :current_sign_in_at
		column :last_sign_in_at
		column :current_sign_in_ip
		column :last_sign_in_ip
		default_actions
	end

	sidebar "User Details", only: [:show] do
    ul do
      li link_to("Signed Request Users", admin_user_signed_request_users_path(user))
      li link_to("Email Accounts", admin_user_email_accounts_path(user))
    end
  end

  form do |f|
		f.inputs do
			f.input :first_name
			f.input :last_name
			f.input :short_name
			f.input :email
			f.input :password
			f.input :password_confirmation
		end
		f.inputs do
	    f.has_many :email_accounts, :allow_destroy => true do |eaf|
	  		eaf.input :username
	  		eaf.input :authentication_string
	  		eaf.input :status_id
	  		eaf.input :server
	  		eaf.input :port
	    end
	    f.actions
	  end
  end  
	show do |ad|
    attributes_table do
    	row :name
    	row :short_name
      row :email
      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
    end
  end

  controller do
  	 def update
		   @user = User.find(params[:id])
		   if params[:user][:password].blank?
		     @user.update_without_password(params[:user])
		   else
		     @user.update_attributes(params[:user])
		   end
		   if @user.errors.blank?
		     redirect_to admin_users_path, :notice => "User updated successfully."
		   else
		     render :edit
		   end
		 end
  end
end
