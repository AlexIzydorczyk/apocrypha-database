class LanguageReferencesController < ApplicationController
  before_action :set_language_reference, only: %i[ show edit update destroy ]

  def index
    @language_references = LanguageReference.all
  end

  def show
  end

  def new
    @language_reference = LanguageReference.new
  end

  def edit
  end

  def create
    @language_reference = LanguageReference.new(language_reference_params)

    if @language_reference.save
      redirect_to language_references_url, notice: "Language reference was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @language_reference.update(language_reference_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to language_references_url, notice: "Language reference was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @language_reference.destroy
    redirect_to language_references_url, notice: "Language reference was successfully destroyed."
  end

  private
    def set_language_reference
      @language_reference = LanguageReference.find(params[:id])
    end

    def language_reference_params
      params.require(:language_reference).permit(:record_id, :language_id)
    end
end
