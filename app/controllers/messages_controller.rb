class MessagesController < ApplicationController
  def index
    @party = parent_object
    @messages = @party.messages

    respond_to do |format|
      format.html
      format.json { render json: @messages }
    end
  end

  def show
    @message = current_object

    respond_to do |format|
      format.html
      format.json { render json: @message }
    end
  end

  protected

    def current_object
      @current_object ||= Message.user(current_user).find(params[:id])
    end

    def parent_object
      @parent_object ||= Party.user(current_user).find(params[:party_id])
    end
end
