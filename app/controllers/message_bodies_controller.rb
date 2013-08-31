class MessageBodiesController < ApplicationController
  def show
    @message = Message.user(current_user).find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @message, serializer: MessageBodySerializer, root: 'message_body' }
    end
  end

end