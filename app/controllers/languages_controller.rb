class LanguagesController < ApplicationController
  before_action :set_language, only: %i[ show edit update destroy ]

  def index
    @languages = Language.all
  end

  def show
  end

  def new
    @language = Language.new
  end

  def edit
  end

  def create
    @language = Language.create(language_params)  
    
    if params[:record_class].present?
      r = params[:record_class].constantize.find(params[:record_id])
      r[params[:record_field_name]] = @language.id
      r.save
    end
    # if @language.save
    #   # redirect_to languages_url, notice: "Language was successfully created."
    # else
    #   render :new, status: :unprocessable_entity
    # end
  end

  def update
    if @language.update(language_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to languages_url, notice: "Language was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @language.destroy
    redirect_to languages_url, notice: "Language was successfully destroyed."
  end

  private
    def set_language
      @language = Language.find(params[:id])
    end

    def language_params
      params.require(:language).permit(:language_name, :requires_transliteration)
    end
end
