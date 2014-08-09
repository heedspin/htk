require 'import_single_email'

class EmailFactory
	class << self
	  include ImportSingleEmail
		def create_email(args)
			from_email = args[:email]
			for_thread = args[:thread] # set as related email
			include_participants = args[:include_participants]
			email_account = args[:email_account] || (raise ':email_account required')
			if email_account.is_a?(String)
				email_account = EmailAccount.find_by_username(email_account)
				return nil unless email_account
			end
			email = email_account.emails.build(
				subject: args[:subject] || from_email.try(:subject) || for_thread.try(:subject) || "subject-#{Email.count + 1}",
				date: args[:date] || from_email.try(:date) || for_thread.try(:date).try(:advance, minutes: 1) || Time.current,
				to_addresses: args[:to_addresses] || from_email.try(:to_addresses) || for_thread.try(:to_addresses) || ['to-nobody@nowhere.com'],
				cc_addresses: args[:cc_addresses] || from_email.try(:cc_addresses) || for_thread.try(:cc_addresses) || ['cc-nobody@nowhere.com'],
				web_id: args[:web_id] || "web-id-#{Email.count + 1}",
				from_address: args[:from_address] || (from_email.try(:from_address) || email_account.username),
				thread_id: for_thread.try(:thread_id) || "thread-id-#{EmailAccountThread.count + 1}"
			)
			import_single_email(email)
  		if include_participants
  			email.participants.select { |a| a != email_account.username }.each do |email_address|
		   		create_email(email_account: email_address, email: email)
		   	end
  		end
  		email
		end
	end
end