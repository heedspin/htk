class DeliverableFactory
	class << self
		def create(args)
			args = args.dup
			params = args[:params] ||= {}
			params[:title] ||= "Deliverable #{Deliverable.count + 1}"
			params[:status_id] ||= LifeStatus.active.id
	  	params[:deliverable_type_id] ||= DeliverableTypeConfig.standard.id
	  	deliverable_type_config = DeliverableTypeConfig.find(params[:deliverable_type_id])
			current_user = args[:current_user] || (raise ':current_user required')
			email = args[:email] ||= EmailFactory.create_email(user: current_user)
	  	deliverable = deliverable_type_config.ar_type_class.create_from_email(
				email: email, 
				current_user: current_user,  
				params: params)

	  	if relate_args = args[:relate]
	  		unless relate_args.is_a?(Hash)
	  			relate_args = {}
	  		end
				relation_params = {
					relation_type_id: DeliverableRelationType.parent.id,
					message_thread_id: email.message.message_thread_id, 
					target_deliverable_id: deliverable.id					
				}.merge(relate_args)
				DeliverableRelationFactory.create(relation_params)
			end
			deliverable
		end
	end
end