require 'import_single_email'

class EmailFactory
	class << self
	  include ImportSingleEmail
		def create(args)
			from_email = args[:email] || args[:from_email]
			for_thread = args[:thread] # set as related email
			include_participants = args[:include_participants]
			user = args[:current_user] || args[:user] || (raise ':current_user required')
			email = Email.new(
				user: user,
				subject: args[:subject] || from_email.try(:subject) || for_thread.try(:subject) || "subject-#{Email.count + 1}",
				date: args[:date] || from_email.try(:date) || for_thread.try(:date).try(:advance, minutes: 1) || Time.current,
				to_addresses: args[:to_addresses] || from_email.try(:to_addresses) || for_thread.try(:to_addresses) || ['to-nobody@nowhere.com'],
				cc_addresses: args[:cc_addresses] || from_email.try(:cc_addresses) || for_thread.try(:cc_addresses) || ['cc-nobody@nowhere.com'],
				web_id: args[:web_id] || "web-id-#{Email.count + 1}",
				from_address: args[:from_address] || (from_email.try(:from_address) || user.email),
				thread_id: for_thread.try(:thread_id) || "thread-id-#{EmailAccountThread.count + 1}",
				snippet: args[:snippet] || (from_email.try(:snippet))
			)
			import_single_email(email)
  		if include_participants
  			email.participants.select { |a| a != user.email }.each do |email_address|
  				if participant_user = User.active.email(email_address).first
			   		create_email(user: participant_user, email: email)
			   	end
		   	end
  		end
  		email
		end
	end
end