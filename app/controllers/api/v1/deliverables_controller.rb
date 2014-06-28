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
		results = Deliverable.editable_by(current_user).title_like(search_term).not_deleted.by_created_at_desc.limit(20).all.map do |d|
    	{ :label => d.title, :value => d.id }
		end
    render :json => results.to_json
	end

	def search_index
		if @email = Email.user(current_user).from_address(params[:from_address]).date(params[:date]).first
			if (new_web_id = params[:web_id]) and (@email.web_id != new_web_id)
				Email.find(@email.id).update_attributes(web_id: new_web_id)
			end
			@relations = DeliverableRelation.message_thread_id(@email.message.message_thread_id).not_deleted.all
			deliverable_ids = @relations.map { |r| [r.source_deliverable_id, r.target_deliverable_id] }.flatten
			@deliverables = Deliverable.not_deleted.where(:id => deliverable_ids)
			@deliverable_types = DeliverableType.deliverable_types(@deliverables.map(&:type)).all
			
			# render json: deliverables
			# render json: { deliverables: @deliverables, email: EmailSerializer.new(@email, root: false) }
			deliverable_users = @deliverables.map(&:significant_users).flatten.uniq
			render json: { 
				deliverables: @deliverables.map { |d| DeliverableSerializer.new(d, root: false) }, 
				email: EmailSerializer.new(@email, root: false),
				deliverable_users: deliverable_users.map { |du| DeliverableUserSerializer.new(du, root: false) },
				users: deliverable_users.map(&:user).uniq.map { |u| UserSerializer.new(u, root: false) },
				deliverable_relations: @relations.map { |r| DeliverableRelationSerializer.new(r, root: false) },
				deliverable_types: @deliverable_types.map { |t| DeliverableTypeSerializer.new(t, root: false) }
			}
		else
			render json: { result: 'no email' }, status: 404
		end
  end
  
  def create
  	# email = Email.user(current_user).from_address(params[:from_address]).date(params[:date]).first
  	email = Email.user(current_user).find(params[:email_id])
		@deliverable = Deliverable.web_create(email: email, 
			current_user: current_user,  
			params: params)
		deliverable_users = @deliverable.deliverable_users.select(&:significant?)
		render json: { 
			deliverable: DeliverableSerializer.new(@deliverable, root: false), 
			deliverable_users: deliverable_users.map { |du| DeliverableUserSerializer.new(du, root: false) },
			users: deliverable_users.map(&:user).uniq.map { |u| UserSerializer.new(u, root: false) },
			deliverable_type: DeliverableTypeSerializer.new(@deliverable.deliverable_type , root: false)
		}
	end

	def update
		if @deliverable = editable_object
			Deliverable.transaction do
				if @deliverable.update_attributes(title: params[:title], description: params[:description])
					render json: { deliverable: DeliverableSerializer.new(@deliverable, root: false) }
				else
					render json: { errors: @deliverable.errors }, status: 422
				end
			end
		end
	end

	def destroy
		if @deliverable = editable_object
			if @deliverable.destroy
				render json: { result: 'success' }
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
			@deliverable_types = DeliverableType.deliverable_types(@deliverables.map(&:type)).all
			render json: { 
				deliverables: @deliverables.map { |d| DeliverableSerializer.new(d, root: false) }, 
				deliverable_types: @deliverable_types.map { |t| DeliverableTypeSerializer.new(t, root: false) }
			}
		else
			@deliverable = Deliverable.accessible_to(current_user).find(id)
			render json: { 
				deliverable: DeliverableSerializer.new(@deliverable, root: false),
				deliverable_type: DeliverableTypeSerializer.new(@deliverable.deliverable_type , root: false)
			}
		end
	end

	protected

		def editable_object
			Deliverable.editable_by(current_user).find(params[:id]) || not_found
		end
end