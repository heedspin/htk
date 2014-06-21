module ImportSingleEmail
	def import_single_email(email)
		Email.transaction do
  		message = Message.find_or_create(email)
			# TODO: ensure MessageThread always created.
  		email.message = message
  		if message.message_thread
  			eat = message.message_thread.email_account_threads.email_account(email.email_account).first
  			if eat.nil?
  				eat = email.create_email_account_thread!(email_account: email.email_account, 
  					message_thread: message.message_thread, 
  					subject: email.subject, 
  					start_time: email.date,
  					thread_id: message.message_thread.id)
  			elsif email.date < eat.start_time
  				eat.update_attributes! start_time: email.date
  			end
				email.email_account_thread = eat
  		else # New message.
  			message_thread = nil
  			if email.email_account_thread = EmailAccountThread.find_by_thread_id(email.thread_id)
  				message_thread = email.email_account_thread.message_thread
  			else
  				message_thread = MessageThread.create!
  				eat = email.create_email_account_thread!(email_account: email.email_account, 
  					message_thread: message_thread, 
  					subject: email.subject, 
  					start_time: email.date,
  					thread_id: message_thread.id)
  			end
  			message.update_attributes! message_thread: message_thread
  		end
  		email.save!
  		# Label the email.
  		DeliverableRelation.top_level.message_thread_id(message.message_thread_id).each do |dr|
  			CopyToDeliverableFolder.new(dr).copy_email_to_folder(email)
  		end
  	end
  	email
 	end
end