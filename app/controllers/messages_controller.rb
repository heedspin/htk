class MessagesController < ApplicationController
  def index
    @party = Party.user(current_user).find(params[:party_id])
    @messages = @party.messages.order(:id)
    Email.attach_to(@messages)
    EmailAccount.attach_to(@messages)
    respond_to do |format|
      format.html
      format.json { 
        render json: @messages 
      }
    end
  end

  def show
    @message = current_object

    respond_to do |format|
      format.html
      format.json { render json: @message }
    end
  end

  def update
    @message = current_object
    message_params = params[:message] || {}
    %w(date subject html_body party_id).each { |a| message_params.delete(a) }
    respond_to do |format|
      format.json do
        if @message.update_attributes(message_params)
          render json: @message
        else
          render json: @message.errors, status: 422
        end
      end
    end
  end

  protected

    def current_object
      @current_object ||= Message.user(current_user).find(params[:id], :readonly => false)
    end

    def parent_object
      @parent_object ||= Party.user(current_user).find(params[:party_id])
    end
end
