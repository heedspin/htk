ActiveAdmin.register EmailComment do
	index do
		column :email_send_time
		column :email_sender
		column :comment
		default_actions
	end
end