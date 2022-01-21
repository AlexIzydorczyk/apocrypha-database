class OwnershipsController < ApplicationController
  before_action :set_ownership, only: %i[ show edit update destroy ]

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

    if @ownership.save
      # render :json => { new_url: ownership_path(@ownership) }
      #redirect_to ownerships_url, notice: "Ownership was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @ownership.update(ownership_params)
      if request.xhr?
        render :json => {"status": "updated"}  
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
    redirect_to ownerships_url, notice: "Ownership was successfully destroyed."
  end

  private
    def set_ownership
      @ownership = Ownership.find(params[:id])
    end

    def ownership_params
      params.require(:ownership).permit(:booklet_id, :person_id, :institution_id, :location_id, :religious_order_id, :date_from, :date_to, :date_for_owner, :owner_date_is_approximate, :provenance_notes, :manuscript_id)
    end
end
