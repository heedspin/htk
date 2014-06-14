class Api::V1::UsersController < Api::V1::ApiController
	respond_to :json

	def show
		if params[:id] == 'current'
			render json: current_user
		else
			render json: { result: "Not allowed" }, status: :forbidden
		end
	end


  def index
    @users = User.accessible_to(current_user).all
		render json: @users    
  end

end