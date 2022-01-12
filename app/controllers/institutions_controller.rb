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

    if @institution.save
      redirect_to institutions_url, notice: "Institution was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @institution.update(institution_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to institutions_url, notice: "Institution was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @institution.destroy
    redirect_to institutions_url, notice: "Institution was successfully destroyed."
  end

  private
    def set_institution
      @institution = Institution.find(params[:id])
    end

    def institution_params
      params.require(:institution).permit(:name_english, :name_orig, :name_orig_transliteration, :location_id)
    end
end
