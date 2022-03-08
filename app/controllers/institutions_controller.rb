class InstitutionsController < ApplicationController
  before_action :set_institution, only: %i[ show edit update destroy ]

  def index
    @institutions = Institution.all
  end

  def show
  end

  def new
    @institution = Institution.new
  end

  def edit
  end

  def create
    @institution = Institution.new(institution_params)
    saved = @institution.save
    if params[:manuscript_id].present?
      Manuscript.find(params[:manuscript_id]).update(institution_id: @institution.id)
    elsif params[:booklet_id].present?
      Booklet.find(params[:booklet_id]).update(genesis_institution_id: @institution.id)
    elsif params[:ownership_id].present?
      Ownership.find(params[:ownership_id]).update(institution_id: @institution.id)
    elsif params[:modern_source_id].present?
      ModernSource.find(params[:modern_source_id]).update(institution_id: @institution.id)
    end
    if saved && !request.xhr?
      # redirect_path = params[:manuscript_id].present? ? edit_manuscript_path(params[:manuscript_id]) : (params[:booklet_id].present? ? edit_manuscript_booklet_path(Booklet.find(params[:booklet_id]).manuscript, params[:booklet_id]) : institutions_path)
      # redirect_to redirect_path, notice: "Institution was successfully created."
    elsif saved && request.xhr?
      render json: { new_url: institution_path(@institution), id: @institution.id }
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if params[:ownership_id].present?
      Ownership.find(params[:ownership_id]).update(institution_id: @institution.id)
    end
    if @institution.update(institution_params)
      if request.xhr?
        render :json => { new_url: insitution_path(@institution), id: @institution }  
      else
        # redirect_to institutions_url, notice: "Institution was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      @institution.destroy
      redirect_to institutions_url, notice: "Institution was successfully destroyed."
    rescue StandardError => e
      redirect_to institutions_url, alert: "Object could not be deleted because it's being used somewhere else in the system"
    end
  end

  private
    def set_institution
      @institution = Institution.find(params[:id])
    end

    def institution_params
      params.require(:institution).permit(:name_english, :name_orig, :name_orig_transliteration, :location_id, :original_language)
    end
end
