class ManuscriptsController < ApplicationController
  before_action :set_manuscript, only: %i[ show edit update destroy ]

  def index
    @manuscripts = Manuscript.all
  end

  def show
  end

  def new
    @manuscript = Manuscript.new
    @languages = Language.all
  end

  def edit
    @languages = Language.all
  end

  def create
    @manuscript = Manuscript.new(manuscript_params)

    if @manuscript.save
      redirect_to manuscripts_url, notice: "Manuscript was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @manuscript.update(manuscript_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        puts @manuscript.language_references
        redirect_to manuscripts_url, notice: "Manuscript was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @manuscript.destroy
    redirect_to manuscripts_url, notice: "Manuscript was successfully destroyed."
  end

  private
    def set_manuscript
      @manuscript = Manuscript.find(params[:id])
    end

    def manuscript_params
      params.require(:manuscript).permit(:identifier, :census_no, :status, :institution_id, :shelfmark, :old_shelfmark, :material, :dimensions, :leaf_page_no, :date_from, :date_to, :content_type, :notes, :languages)
    end
end
