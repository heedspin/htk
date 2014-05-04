class Api::V1::MessagesController < ApplicationController
  def index
    if @email = Email.user(current_user).from_address(params[:from_address]).date(params[:date]).first
      if (new_web_id = params[:web_id]) and (@email.web_id != new_web_id)
        Email.find(@email.id).update_attributes(web_id: new_web_id)
      end
      @messages = [ @email.message ]
      render json: @messages
    else
      render json: { result: 'no email' }, status: 404
    end
  end
end
