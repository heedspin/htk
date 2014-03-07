class DeliverableFactory
	class << self
		def create_deliverable(args)
			args = args.clone
			args[:title] ||= "Deliverable #{Deliverable.count + 1}"
			current_user = args[:current_user] || (raise ':current_user required')
			args[:email] ||= EmailFactory.create_email(email_account: current_user.email_accounts.first)
			Deliverable.web_create(args)
		end
	end
end