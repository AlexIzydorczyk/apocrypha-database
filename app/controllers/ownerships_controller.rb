class OwnershipsController < ApplicationController
  before_action :set_ownership, only: %i[ show edit update destroy ]
  skip_before_action :authenticate_user!, only: %i[ index ]
  before_action :allow_for_editor, only: %i[ edit update destroy create ]

  def index
    @ownerships = Ownership.all
  end

  def show
  end

  def new
    @ownership = Ownership.new
  end

  def edit
  end

  def create
    @ownership = Ownership.new(ownership_params)
    ChangeLog.create(user_id: current_user.id, record_type: 'Ownership', record_id: @ownership.id, controller_name: 'ownership', action_name: 'create')

    if @ownership.save
      if request.xhr?
        render :json => { new_url: ownership_path(@ownership), id: @ownership.id }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @ownership.update(ownership_params)
      ChangeLog.create(user_id: current_user.id, record_type: 'Ownership', record_id: @ownership.id, controller_name: 'ownership', action_name: 'update')
      if request.xhr?
        render :json => {id: @ownership.id}  
      else
        redirect_path = params[:moved_to_booklet] ? edit_manuscript_path(@ownership.booklet.manuscript) : ownerships_path
        notice = params[:moved_to_booklet] ? "Provenance was successfully moved to booklet." : "Ownership was successfully updated."
        redirect_to redirect_path, notice: notice
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @ownership.destroy
    ChangeLog.create(user_id: current_user.id, record_type: 'Ownership', record_id: @ownership.id, controller_name: 'ownership', action_name: 'destroy')
    redirect_to ownerships_url, notice: "Ownership was successfully destroyed." unless request.xhr?
  end

  private
    def set_ownership
      @ownership = Ownership.find(params[:id])
    end

    def ownership_params
      params.require(:ownership).permit(:booklet_id, :person_id, :institution_id, :location_id, :religious_order_id, :date_from, :date_to, :specific_date, :date_exact, :provenance_notes, :manuscript_id)
    end
end
