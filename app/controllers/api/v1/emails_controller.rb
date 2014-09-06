class Api::V1::EmailsController < Api::V1::ApiController
	respond_to :json
  def index
    @emails = Email.user(current_user).not_deleted.from_address(params[:from_address]).date(params[:date])
    render json: @emails
  end
end
