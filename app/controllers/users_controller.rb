class UsersController < ApplicationController
  def show
    @user = current_object

    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  protected

    def current_object
      @current_object ||= if params[:id] == 'current'
        current_user
      else
        User.find(params[:id])
      end
    end
end
