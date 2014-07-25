class Api::V1::Deliverables::PermissionsController < Api::V1::ApiController
	respond_to :json
  def create
  	@deliverable = editable_parent_object
  	@user = User.accessible_to(current_user).find(params[:user_id])
  	if @permission = @deliverable.permissions.where(user_id: @user.id).first
  		# If the user has no permissions, the DU will not be on the client.  Make sure we update existing record in that case.
  		assign_params(@permission)
  	else
  		@permission = @deliverable.permissions.build(user_id: @user.id, responsible: params[:responsible], access_id: params[:access_id], group_id: current_user.user_group_id)
	  end
  	if @permission.save
			render json: { permission: PermissionSerializer.new(@permission, root: false) }
		else
			render json: { errors: @permission.errors }, status: 422
		end
	end

	def update
  	@deliverable = editable_parent_object
  	@user = User.accessible_to(current_user).find(params[:user_id])
  	@permission = @deliverable.permissions.find(params[:id])
  	assign_params(@permission)
  	if @permission.save
			render json: { permission: PermissionSerializer.new(@permission, root: false) }
		else
			render json: { errors: @permission.errors }, status: 422
		end
	end

	def destroy
  	@deliverable = editable_parent_object
  	@permission = @deliverable.permissions.find(params[:id])
		if @permission.destroy
			render json: { result: 'success' }
		else
			render json: { errors: @permission.errors }, status: 422
		end	  	
	end

	protected

		def assign_params(du)
 			%w(responsible access_id).each do |key|
	  		@permission.send("#{key}=", params[key]) if params.member?(key)
	  	end
		end

		def editable_parent_object
			@parent_object ||= Deliverable.editable_by(current_user).find(params[:deliverable_id])
		end

end