class Api::V1::DeliverablesController < Api::V1::ApiController
	respond_to :json
	def default_serializer_options
	  {root: 'deliverable'}
	end

	# ActiveModel::Serializer::IncludeError (Cannot serialize deliverable_users when DeliverableSerializer does not have a root!):
	#  app/controllers/api/v1/deliverables_controller.rb:10:in `index'
	def index
    if (search_term = params[:term]).present?
      autocomplete_index(search_term)
    else
      search_index
    end
	end

	def autocomplete_index(search_term)
		results = Deliverable.editable_by(current_user).title_like(search_term).by_created_at_desc.limit(20).all.map do |d|
    	{ :label => d.title, :value => d.id }
		end
    render :json => results.to_json
	end

	def search_index
		if @email = Email.user(current_user).from_address(params[:from_address]).date(params[:date]).first
			if (new_web_id = params[:web_id]) and (@email.web_id != new_web_id)
				Email.find(@email.id).update_attributes(web_id: new_web_id)
			end
			@deliverables = @email.message.message_thread.deliverables.not_deleted
			@deliverables, @relations = DeliverableRelation.get_trees(@deliverables)
			
			# render json: deliverables
			# render json: { deliverables: @deliverables, email: EmailSerializer.new(@email, root: false) }
			deliverable_users = @deliverables.map(&:deliverable_users).flatten.uniq.select(&:significant?)
			render json: { 
				deliverables: @deliverables.map { |d| DeliverableSerializer.new(d, root: false) }, 
				email: EmailSerializer.new(@email, root: false),
				deliverable_users: deliverable_users.map { |du| DeliverableUserSerializer.new(du, root: false) },
				users: deliverable_users.map(&:user).uniq.map { |u| UserSerializer.new(u, root: false) },
				deliverable_relations: @relations.map { |r| DeliverableRelationSerializer.new(r, root: false) }
			}
		else
			render json: { result: 'no email' }, status: 404
		end
  end
  
  def create
  	title = params[:title] || 'Deliverable'
  	email = Email.user(current_user).from_address(params[:from_address]).date(params[:date]).first
		if email.nil?
  		render json: { result: 'no email' }, status: 422
  	else
  		Deliverable.transaction do 
	  		@deliverable = Deliverable.web_create(email: email, 
	  			current_user: current_user, 
	  			title: title, 
	  			description: params[:description])
	  		if (parent_id = params[:parent_id]).present?
          DeliverableRelation.create!(source_deliverable_id: parent_id, 
            target_deliverable_id: @deliverable.id,
            relation_type_id: DeliverableRelationType.parent.id)
        end
	  	end
			deliverable_users = @deliverable.deliverable_users.select(&:significant?)
			render json: { 
				deliverable: DeliverableSerializer.new(@deliverable, root: false), 
				deliverable_users: deliverable_users.map { |du| DeliverableUserSerializer.new(du, root: false) },
				users: deliverable_users.map(&:user).uniq.map { |u| UserSerializer.new(u, root: false) }
			}
	  end
	end

	def update
		if @deliverable = editable_object
			Deliverable.transaction do
				if (parent_id = params[:parent_id]).present?
					@deliverable.parent_relations.map(&:destroy)
          DeliverableRelation.create!(source_deliverable_id: parent_id, 
            target_deliverable_id: @deliverable.id,
            relation_type_id: DeliverableRelationType.parent.id)
				end					
				if @deliverable.update_attributes(title: params[:title], description: params[:description])
					render json: { result: 'success'}
				else
					render json: { errors: @deliverable.errors }, status: 422
				end
			end
		end
	end

	def destroy
		if @deliverable = editable_object
			if @deliverable.destroy
				render json: { result: 'success'}
			else
				render json: { errors: @deliverable.errors }, status: 422
			end	
		end
	end

	def show
		id = params[:id]
		if id == 'recent'
			@deliverables = Deliverable.editable_by(current_user).not_deleted.by_created_at_desc.limit(20)
			if excluding = params[:exclude]
				@deliverables = @deliverables.excluding(excluding)
			end
			render json: @deliverables
		else
			@deliverable = Deliverable.accessible_to(current_user).find(id)
			render json: @deliverable
		end
	end

	protected

		def editable_object
			Deliverable.editable_by(current_user).find(params[:id]) || not_found
		end
end