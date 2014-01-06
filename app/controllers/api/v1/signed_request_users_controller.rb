class Api::V1::SignedRequestUsersController < Api::V1::ApiController
	respond_to :json
	skip_before_filter :verify_signed_user

	def create
		if SignedRequestUser.owner_container(params[:opensocial_owner_id], params[:opensocial_container]).first
			render json: { result: 'already exists' }, status: 200
		elsif (user = User.find_by_email(params[:email])) and user.valid_password?(params[:password])
			SignedRequestUser.create!(user: user,
				original_opensocial_app_id: params[:opensocial_app_id],
				original_opensocial_app_url: params[:opensocial_app_url],
				opensocial_owner_id: params[:opensocial_owner_id],
				opensocial_container: params[:opensocial_container])
			sign_in(:user, user)
			render json: { result: 'success' }, status: 200
		else
			render json: { result: 'login failed' }, status: 401
		end
	end
end