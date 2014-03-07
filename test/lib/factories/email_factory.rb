class EmailFactory
	class << self
		def create_email(args)
			args = args.clone
			from_email = args.delete(:email)
			for_thread = args.delete(:thread)
			include_participants = args.delete(:include_participants)
			args[:subject] ||= from_email.try(:subject) || for_thread.try(:subject) || "subject-#{Email.count + 1}"
			args[:date] ||= from_email.try(:date) || for_thread.try(:date).try(:advance, minutes: 1) || Time.current
			args[:to_addresses] ||= from_email.try(:to_addresses) || for_thread.try(:to_addresses) || ['to-nobody@nowhere.com']
			args[:cc_addresses] ||= from_email.try(:cc_addresses) || for_thread.try(:cc_addresses) || ['cc-nobody@nowhere.com']
			email_account = args.delete(:email_account) || (raise ':email_account required')
			if email_account.is_a?(String)
				email_account = EmailAccount.find_by_username(email_account)
				return nil unless email_account
			end
			args[:web_id] ||= "web-id-#{Email.count + 1}"
			args[:from_address] ||= (from_email.try(:from_address) || email_account.username)
  		email = Email.web_create(email_account, args)
  		if include_participants
  			email.participants.select { |a| a != email_account.username }.each do |email_address|
		   		create_email(email_account: email_address, email: email)
		   	end
  		end
  		email
		end
	end
end