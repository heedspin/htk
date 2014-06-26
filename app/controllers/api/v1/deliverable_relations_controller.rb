class Api::V1::DeliverableRelationsController < Api::V1::ApiController
	def create
  	@message_thread = MessageThread.accessible_to(current_user).find(params[:message_thread_id])
  	if (source_deliverable_id = params[:source_deliverable_id]).present?
	  	@source_deliverable = Deliverable.editable_by(current_user).find(source_deliverable_id)
	  end
  	@target_deliverable = Deliverable.editable_by(current_user).find(params[:target_deliverable_id])
  	if (previous_sibling_id = params[:previous_sibling_id]).present?
	  	@previous_sibling = Deliverable.editable_by(current_user).find(previous_sibling_id)
	  end
		@relation = DeliverableRelation.new(
			message_thread_id: @message_thread.id,
			source_deliverable_id: @source_deliverable.try(:id),
			target_deliverable_id: @target_deliverable.id,
			previous_sibling_id: @previous_sibling.try(:id),
			relation_type_id: params[:relation_type_id],
			status_id: params[:status_id] || LifeStatus.active.id)
		if @relation.save
			render json: @relation
		else
			render json: { errors: @relation.errors }, status: 422
		end
	end

	def update
		@relation = DeliverableRelation.find(params[:id])
		all_related_deliverable_ids = %w(source_deliverable_id target_deliverable_id previous_sibling_id).map do |k| 
			# Only set id if it's a param (allows clearing of value)
			if new_id = params[k]
				@relation.send("#{k}=", new_id)
			end
			[@relation.send(k), new_id]
		end.flatten.select(&:present?).map(&:to_i).uniq
		accessible_deliverables = Deliverable.editable_by(current_user).where(:id => all_related_deliverable_ids).count
		if all_related_deliverable_ids.size == accessible_deliverables
		  if (relation_type_id = params[:relation_type_id])
		  	@relation.relation_type_id = relation_type_id
		  end
			if @relation.save
				render json: { result: 'success' }
			else
				render json: { errors: @relation.errors }, status: 422
			end
		else
			render json: { error: 'access denied' }, status: 403
		end
	end

	def destroy
  	@relation = DeliverableRelation.find(params[:id])
  	access_check = Deliverable.editable_by(current_user).find(@relation.target_deliverable_id)
  	if @relation.destroy
  		render json: { result: 'success' }
  	else
			render json: { errors: @relation.errors }, status: 422
  	end
	end

end