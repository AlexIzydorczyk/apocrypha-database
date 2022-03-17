class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  def index
    @users = User.all
  end

  def create
    @user = User.new(user_params)

    if @user.save
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to users_url, notice: "User was successfully created."
      end
    end

  end

  def update
    if @user.update(user_params)
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