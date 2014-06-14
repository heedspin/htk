class Api::V1::DeliverableUsersController < Api::V1::ApiController
	respond_to :json
  def create
  	@deliverable = editable_parent_object
  	@user = User.accessible_to(current_user).find(params[:user_id])
  	if @deliverable_user = @deliverable.deliverable_users.where(user_id: @user.id).first
  		# If the user has no permissions, the DU will not be on the client.  Make sure we update existing record in that case.
  		assign_params(@deliverable_user)
  	else
  		@deliverable_user = @deliverable.deliverable_users.build(user_id: @user.id, responsible: params[:responsible], access_id: params[:access_id])
	  end
  	if @deliverable_user.save
			render json: { deliverable_user: DeliverableUserSerializer.new(@deliverable_user, root: false) }
		else
			render json: { errors: @deliverable_user.errors }, status: 422
		end
	end

	def update
  	@deliverable = editable_parent_object
  	@user = User.accessible_to(current_user).find(params[:user_id])
  	@deliverable_user = @deliverable.deliverable_users.find(params[:id])
  	assign_params(@deliverable_user)
  	if @deliverable_user.save
			render json: { deliverable_user: DeliverableUserSerializer.new(@deliverable_user, root: false) }
		else
			render json: { errors: @deliverable_user.errors }, status: 422
		end
	end

	def destroy
  	@deliverable = editable_parent_object
  	@deliverable_user = @deliverable.deliverable_users.find(params[:id])
		if @deliverable_user.destroy
			render json: { result: 'success' }
		else
			render json: { errors: @deliverable_user.errors }, status: 422
		end	  	
	end

	protected

		def assign_params(du)
 			%w(responsible access_id).each do |key|
	  		@deliverable_user.send("#{key}=", params[key]) if params.member?(key)
	  	end
		end

		def editable_parent_object
			@parent_object ||= Deliverable.editable_by(current_user).find(params[:deliverable_id])
		end

end