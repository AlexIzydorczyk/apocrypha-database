class UsersController < ApplicationController
  before_action :allow_for_admin
  before_action :set_user, only: %i[ show edit update destroy ]
  

  def index
    @users = User.all
  end

  def create
    @user = User.new(user_params)

    if @user.save
      ChangeLog.create(user_id: current_user.id, record_type: 'User', record_id: @user.id, controller_name: 'user', action_name: 'create')
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to users_url, notice: "User was successfully created."
      end
    end

  end

  def update
    if @user.update(user_params)
      ChangeLog.create(user_id: current_user.id, record_type: 'User', record_id: @user.id, controller_name: 'user', action_name: 'update')
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to users_url, notice: "User was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :role)
  end

end