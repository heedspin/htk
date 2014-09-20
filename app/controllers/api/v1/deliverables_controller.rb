require 'get_deliverable_tree'
class Api::V1::DeliverablesController < Api::V1::ApiController
	include GetDeliverableTree
	respond_to :json
	def default_serializer_options
	  {root: 'deliverable'}
	end

	# ActiveModel::Serializer::IncludeError (Cannot serialize deliverable_users when DeliverableSerializer does not have a root!):
	#  app/controllers/api/v1/deliverables_controller.rb:10:in `index'
	def index
    if (search_term = params[:term]).present?
      autocomplete_index(search_term)
    elsif (from_address = params[:from_address]) and (date = params[:date])
      index_by_email(from_address, date)
    else
    	index_by_params
    end
	end

	def autocomplete_index(search_term)
		results = Deliverable.editable_by(current_user).title_like(search_term).not_deleted.by_created_at_desc.limit(20).all.map do |d|
    	{ :label => d.title, :value => d.id }
		end
    render :json => results.to_json
	end

	def index_by_email(from_address, date)
		if @email = Email.user(current_user).from_address(from_address).date(date).first
			if (new_web_id = params[:web_id]) and (@email.web_id != new_web_id)
				Email.find(@email.id).update_attributes(web_id: new_web_id)
			end
			@relations = DeliverableRelation.message_or_thread(@email.message.id, @email.message.message_thread_id).not_deleted.top_level.all
			json_response = get_deliverable_tree(relations: @relations, serialize: true)
			json_response[:email] = EmailSerializer.new(@email, root: false)
			render json: json_response
		else
			render json: { result: 'no email' }, status: 404
		end
  end

  def index_by_params
  	user = current_user
  	if user_id = params[:user_id]
  		if user_id != user.id
	  		user = User.find(user_id)
	  		raise Exceptions::AccessDenied unless (user.user_group_id == current_user.user_group_id)
	  	end
	  end
	  @deliverables = Deliverable.not_deleted.user_group(current_user.user_group_id)
  	if responsible_user_id = params[:responsible_user_id]
  		if responsible_user_id == 'me'
  			responsible_user_id = current_user.id
  		end
  		@deliverables = @deliverables.responsible_user(responsible_user_id)
  	end
  	if creator_id = params[:creator_id]
  		if creator_id == 'me'
  			creator_id = current_user.id
  		end
  		@deliverables = @deliverables.creator(creator_id)
  	end
  	if created_after = params[:created_after]
  		begin
	  		@deliverables = @deliverables.created_after(Deliverable.find(created_after).created_at)
	  	rescue
	  	end
  	end
  	if type = params[:type]
  		@deliverables = @deliverables.deliverable_type(type)
  	end
		json_response = get_deliverable_tree(deliverables: @deliverables, serialize: true)
		render json: json_response
  end
  
  def create
  	# email = Email.user(current_user).from_address(params[:from_address]).date(params[:date]).first
  	email = Email.user(current_user).find(params[:email_id])
  	deliverable_type_id = params[:deliverable_type_id]
  	if deliverable_type_config = DeliverableTypeConfig.find(deliverable_type_id)
  		@deliverable_type = current_user.preferences.deliverable_types.deliverable_type_config(deliverable_type_config).first
  		if @deliverable_type
	  		@deliverable = deliverable_type_config.ar_type_class.create_from_email(
	  			email: email, 
					current_user: current_user,  
					params: params)
	  		permissions = @deliverable.permissions.responsible
	  		users = (permissions.map(&:user) + [@deliverable.creator]).uniq
				render json: { 
					deliverable: DeliverableSerializer.new(@deliverable, root: false), 
					permissions: permissions.map { |du| PermissionSerializer.new(du, root: false) },
					users: users.map { |u| UserSerializer.new(u, root: false) },
					deliverable_type: DeliverableTypeSerializer.new(@deliverable_type, root: false)
				}
			else
				render json: { errors: ["Deliverable type id '#{deliverable_type_id}' is not configured / enabled"] }, status: 422
			end
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