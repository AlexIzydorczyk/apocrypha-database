class ChangeLogsController < ApplicationController
  before_action :set_change_log, only: %i[ show edit update destroy ]

  def index
    @change_logs = ChangeLog.all
  end

  def show
  end

  def new
    @change_log = ChangeLog.new
  end

  def edit
  end

  def create
    @change_log = ChangeLog.new(change_log_params)

    if @change_log.save
      redirect_to change_logs_url, notice: "Change log was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @change_log.update(change_log_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to change_logs_url, notice: "Change log was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @change_log.destroy
    redirect_to change_logs_url, notice: "Change log was successfully destroyed."
  end

  private
    def set_change_log
      @change_log = ChangeLog.find(params[:id])
    end

    def change_log_params
      params.require(:change_log).permit(:user_id, :controller_name, :action_name, :record_id, :additional_info)
    end
end
