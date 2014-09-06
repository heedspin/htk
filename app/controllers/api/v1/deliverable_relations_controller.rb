require 'get_deliverable_tree'
class Api::V1::DeliverableRelationsController < Api::V1::ApiController
	include GetDeliverableTree
	def create
		if message_thread_id = params[:message_thread_id]
	  	@message_thread = MessageThread.accessible_to(current_user).find(message_thread_id)
	  end
  	if (source_deliverable_id = params[:source_deliverable_id]).present?
	  	@source_deliverable = Deliverable.find(source_deliverable_id).ensure_editable_by!(current_user)
	  end
  	@target_deliverable = Deliverable.find(params[:target_deliverable_id]).ensure_editable_by!(current_user)
  	if (previous_sibling_id = params[:previous_sibling_id]).present?
	  	@previous_sibling = Deliverable.find(previous_sibling_id).ensure_editable_by!(current_user)
	  end
		@relation = DeliverableRelation.new(
			message_thread_id: @message_thread.try(:id),
			message_id: params[:message_id],
			source_deliverable_id: @source_deliverable.try(:id),
			target_deliverable_id: @target_deliverable.id,
			previous_sibling_id: @previous_sibling.try(:id),
			relation_type_id: params[:relation_type_id],
			status_id: params[:status_id] || LifeStatus.active.id)
		if @relation.save
			json_response = get_deliverable_tree(relation: @relation, serialize: true)
			# The relation created is stored in the singular. Side effects are stored in the plural.  Embrace it.
			json_response[:deliverable_relations] = json_response[:deliverable_relations].select { |r| r.id != @relation.id }
			json_response[:deliverable_relation] = DeliverableRelationSerializer.new(@relation, root: false)
			render json: json_response
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
		@relation.class.ensure_editable_by!(all_related_deliverable_ids, current_user)
	  if (relation_type_id = params[:relation_type_id])
	  	@relation.relation_type_id = relation_type_id
	  end
		if @relation.save
			render json: { result: 'success' }
		else
			render json: { errors: @relation.errors }, status: 422
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