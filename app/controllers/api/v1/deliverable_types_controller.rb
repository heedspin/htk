class Api::V1::DeliverableTypesController < Api::V1::ApiController
	respond_to :json
  def index
    @types = DeliverableType.user_group(current_user).order(:created_at).all
    render json: @types
  end
end
