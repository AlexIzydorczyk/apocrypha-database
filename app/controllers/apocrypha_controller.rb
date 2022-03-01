class ApocryphaController < ApplicationController
  before_action :set_apocryphon, only: %i[ show edit update destroy ]

  def index
    @apocrypha = Apocryphon.all
  end

  def show
  end

  def new
    @apocryphon = Apocryphon.new
    @languages = Language.all
    @language_references = @apocryphon.language_references.build
  end

  def edit
    @languages = Language.all
    @language_references = @apocryphon.language_references.build
    @english_titles = Title.where(apocryphon_id: @apocryphon.id, language_id: helpers.english_id).all
    @latin_titles = Title.where(apocryphon_id: @apocryphon.id, language_id: helpers.latin_id).all
    @other_english_titles = @english_titles.where.not(id: @apocryphon.main_english_title_id).all
    @other_latin_titles = @latin_titles.where.not(id: @apocryphon.main_latin_title_id).all

    titles = Title.where(apocryphon_id: @apocryphon.id).map(&:id)
    contents = Content.where(title_id: titles).map(&:id)
    texts = Text.where(content_id: contents).map(&:id)
    langRef = LanguageReference.where(record_type: 'Text').where(record_id: texts).map(&:language_id)
    @list_of_languages = Language.where(id: langRef).map(&:language_name).join(', ')
  end

  def create
    @apocryphon = Apocryphon.new(apocryphon_params)
    build_language_references_for params[:language_reference][:id] if params[:language_reference].present?

    if params[:parent_type].present? && params[:parent_id].present?
      parent = params[:parent_type].constantize.find(params[:parent_id])
      c = parent.contents.create
      @apocryphon.content_id = c.id
    end

    if @apocryphon.save
      #redirect_to apocrypha_url, notice: "Apocryphon was successfully created."
      redirect_to edit_apocryphon_path(@apocryphon)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create_from_booklist
    @apocryphon = Apocryphon.new(apocryphon_params)
    build_language_references_for params[:language_reference][:id] if params[:language_reference].present?

    if @apocryphon.save
      booklist_reference = BooklistReference.create(record: @apocryphon, booklist_section_id: params[:booklist_section_id])
      redirect_to edit_apocryphon_path(@apocryphon, old_path: params[:from])
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if params[:language_reference]
      new_set = params[:language_reference][:id].filter{ |id| id.present? }.map{ |id| id.to_i }
      LanguageReference.where(record: @apocryphon, language_id: @apocryphon.languages.ids - new_set).destroy_all
      build_language_references_for new_set - @apocryphon.languages.ids
    end

    if @apocryphon.update(apocryphon_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        if params[:old_path].present?
          redirect_to params[:old_path], notice: "Apocryphon was successfully updated."
        else
          redirect_to apocrypha_url, notice: "Apocryphon was successfully updated."
        end
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @apocryphon.destroy
    redirect_to apocrypha_url, notice: "Apocryphon was successfully destroyed."
  end

  private

  def set_apocryphon
    @apocryphon = Apocryphon.find(params[:id])
  end

  def apocryphon_params
    params.require(:apocryphon).permit(:apocryphon_no, :cant_no, :bhl_no, :bhg_no, :bho_no, :e_clavis_no, :e_clavis_link, :english_abbreviation, :latin_abbreviation, :main_latin_title_id, :main_english_title_id)
  end

  def build_language_references_for ids
    ids.each do |id|
      if id.present?
        @apocryphon.language_references.build(language_id: id)
      end
    end
  end
end
