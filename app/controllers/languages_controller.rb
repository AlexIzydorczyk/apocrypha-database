class LanguagesController < ApplicationController
  before_action :set_language, only: %i[ show edit update destroy ]
  # skip_before_action :authenticate_user!, only: %i[ index ]
  before_action :allow_for_editor, only: %i[ index edit update destroy create ]

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
    ChangeLog.create(user_id: current_user.id, record_type: 'Language', record_id: @language.id, controller_name: 'language', action_name: 'create')
    
    if params[:record_class].present?
      if params[:record_class] == "Manuscript"
        LanguageReference.create(record: Manuscript.find(params[:record_id]), language: @language)
      elsif params[:record_class] == "Booklist"
        Booklist.find(params[:record_id]).update(language: @language)
      else
        r = params[:record_class].constantize.find(params[:record_id])
        r[params[:record_field_name]] = @language.id
        r.save
      end
    end
    if request.xhr?
      render json: {id: @language.id}
    end
    # if @language.save
    #   # redirect_to languages_url, notice: "Language was successfully created."
    # else
    #   render :new, status: :unprocessable_entity
    # end
  end

  def update
    if @language.update(language_params)
      ChangeLog.create(user_id: current_user.id, record_type: 'Language', record_id: @language.id, controller_name: 'language', action_name: 'update')
      if request.xhr?
        render :json => {id: @language.id}  
      else
        redirect_to languages_url, notice: "Language was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @language.destroy
    ChangeLog.create(user_id: current_user.id, record_type: 'Language', record_id: @language.id, controller_name: 'language', action_name: 'destroy')
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
