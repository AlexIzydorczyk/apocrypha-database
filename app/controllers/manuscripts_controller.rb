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
    @language_references = @manuscript.language_references.build
  end

  def edit
    @languages = Language.all
    @language_references = @manuscript.language_references.build
    @contents = @manuscript.contents.map{ |c| {id: c.id, seq: c.sequence_no, title: c.title.try(:title_english), author: c.author.try(:full_name)} }
  end

  def create
    @manuscript = Manuscript.new(manuscript_params)
    build_language_references_for params[:language_reference][:id] if params[:language_reference].present?

    if @manuscript.save
      # render :json => { new_url: manuscript_path(@manuscript) }
      redirect_to edit_manuscript_path(@manuscript)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    new_set = params[:language_reference][:id].filter{ |id| id.present? }.map{ |id| id.to_i }
    LanguageReference.where(record: @manuscript, language_id: @manuscript.languages.ids - new_set).destroy_all
    build_language_references_for new_set - @manuscript.languages.ids

    if @manuscript.update(manuscript_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
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
    params.require(:manuscript).permit(:identifier, :census_no, :status, :institution_id, :shelfmark, :old_shelfmark, :material, :dimensions, :leaf_page_no, :date_from, :date_to, :content_type, :notes, :known_booklet_composition, languages_attributes: [:id])
  end

  def build_language_references_for ids
    ids.each do |id|
      if id.present?
        @manuscript.language_references.build(language_id: id)
      end
    end
  end

end
