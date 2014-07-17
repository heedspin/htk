require 'get_deliverables_json'
class Api::V1::DeliverablesController < Api::V1::ApiController
	include GetDeliverablesJson
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
			@relations = DeliverableRelation.message_or_thread(@email.message.id, @email.message.message_thread_id).not_deleted.top_level.all
			json_response = get_deliverables_json(@relations)
			json_response[:email] = EmailSerializer.new(@email, root: false)
			render json: json_response
		else
			render json: { result: 'no email' }, status: 404
		end
  end
  
  def create
  	# email = Email.user(current_user).from_address(params[:from_address]).date(params[:date]).first
  	email = Email.user(current_user).find(params[:email_id])
  	deliverable_type_id = params[:deliverable_type_id]
  	if deliverable_type_config = DeliverableTypeConfig.find(deliverable_type_id)
  		@deliverable = deliverable_type_config.ar_type_class.create_from_email(
  			email: email, 
				current_user: current_user,  
				params: params)
			permissions = @deliverable.permissions.select(&:significant?)
			render json: { 
				deliverable: DeliverableSerializer.new(@deliverable, root: false), 
				permissions: permissions.map { |du| PermissionSerializer.new(du, root: false) },
				users: permissions.map(&:user).uniq.map { |u| UserSerializer.new(u, root: false) },
				deliverable_type: DeliverableTypeSerializer.new(@deliverable.deliverable_type , root: false)
			}
		else
			render json: { errors: ["Invalid deliverable type id '#{deliverable_type_id}'"] }, status: 422
		end
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