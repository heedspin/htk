class DeliverableFactory
	class << self
		def create(args)
			args = args.clone
			params = args[:params] ||= {}
			params[:title] ||= "Deliverable #{Deliverable.count + 1}"
			params[:status_id] ||= LifeStatus.active.id
			current_user = args[:current_user] || (raise ':current_user required')
			email = args[:email] ||= EmailFactory.create_email(email_account: current_user.email_accounts.first)
			deliverable = Deliverable.web_create(args)
			if !args.member?(:relate) || args[:relate]
				DeliverableRelationFactory.create(message_thread_id: email.message.message_thread_id, target_deliverable_id: deliverable.id)
			end
			deliverable
		end
	end
end