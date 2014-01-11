class Api::V1::EmailCommentsController < Api::V1::ApiController
	respond_to :json

	def index
    render json: {hello_worlds: [{value: 'hello'}, {value: 'world'}]}
  end
  
  def show
    render json: {value: "Hello #{params[:id]}"}
  end  
end