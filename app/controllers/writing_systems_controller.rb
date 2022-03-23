class WritingSystemsController < ApplicationController
  before_action :set_writing_system, only: %i[ show edit update destroy ]
  skip_before_action :authenticate_user!, only: %i[ index ]
  before_action :allow_for_editor, only: %i[ edit update destroy create ]

  def index
    @writing_systems = WritingSystem.all
  end

  def show
  end

  def new
    @writing_system = WritingSystem.new
  end

  def edit
  end

  def create
    @writing_system = WritingSystem.new(writing_system_params)

    if @writing_system.save
      ChangeLog.create(user_id: current_user.id, record_type: 'WritingSystem', record_id: @writing_system.id, controller_name: 'writing_system', action_name: 'create')
      redirect_to writing_systems_url, notice: "Writing system was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @writing_system.update(writing_system_params)
      ChangeLog.create(user_id: current_user.id, record_type: 'WritingSystem', record_id: @writing_system.id, controller_name: 'writing_system', action_name: 'update')
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to writing_systems_url, notice: "Writing system was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @writing_system.destroy
    ChangeLog.create(user_id: current_user.id, record_type: 'WritingSystem', record_id: @writing_system.id, controller_name: 'writing_system', action_name: 'destroy')
    redirect_to writing_systems_url, notice: "Writing system was successfully destroyed."
  end

  private
    def set_writing_system
      @writing_system = WritingSystem.find(params[:id])
    end

    def writing_system_params
      params.require(:writing_system).permit(:name)
    end
end
