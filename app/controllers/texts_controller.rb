class TextsController < ApplicationController
  before_action :set_text, only: %i[ show edit update destroy ]
  skip_before_action :authenticate_user!, only: %i[ index ]
  before_action :allow_for_editor, only: %i[ edit update destroy create ]

  def index
    @texts = Text.all
  end

  def show
  end

  def new
    @text = Text.new
  end

  def edit
    @languages = Language.all
    @language_references = @text.language_references.build
    @section_names = Section.all.pluck(:section_name).uniq.select{ |n| n.present? }
    @modern_sources = ModernSource.left_outer_joins([:authors, :institution]).order("people.last_name_vernacular", "institutions.name", "people.first_name_vernacular", "modern_sources.publication_title_orig", "modern_sources.title_orig").all
    @scribe_reference = @text.scribe_references.build
  end

  def create
    @text = Text.new(text_params)
    build_language_references_for params[:language_reference][:id] if params[:language_reference].present?

    if @text.save
      ChangeLog.create(user_id: current_user.id, record_type: 'Text', record_id: @text.id, controller_name: 'text', action_name: 'create')
      content_parent = @text.content.try(:parent)
      if content_parent.class == Manuscript
        redirect_to edit_manuscript_content_text_path(content_parent, @text.content, @text)
      elsif content_parent.class == Booklet
        redirect_to edit_booklet_content_text_path(content_parent, @text.content, @text)
      else
        redirect_to texts_url, notice: "Text was successfully created."
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    new_set = params[:language_reference][:id].filter{ |id| id.present? }.map{ |id| id.to_i }
    LanguageReference.where(record: @text, language_id: @text.languages.ids - new_set).destroy_all
    build_language_references_for new_set - @text.languages.ids

    if params[:person_reference].present?
      new_set = params[:person_reference][:id].filter{ |id| id.present? }.map{ |id| id.to_i }
      PersonReference.where(record: @text, person_id: @text.scribes.ids - new_set, reference_type: "scribe").destroy_all
      build_scribe_references_for((new_set - @text.scribes.ids), "scribe")
    elsif params[:in_grid].blank?
      @text.scribe_references.destroy_all
    end

    params[:sections].each do |id, prms|
      section = Section.find(id)
      section.update(section_params(prms))
      puts 'section'.red
      puts section.inspect
    end if params[:sections].present?

    if @text.update(text_params)
      ChangeLog.create(user_id: current_user.id, record_type: 'Text', record_id: @text.id, controller_name: 'text', action_name: 'update')
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to texts_url, notice: "Text was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @text.destroy
    ChangeLog.create(user_id: current_user.id, record_type: 'Text', record_id: @text.id, controller_name: 'text', action_name: 'destroy')
    if request.xhr?
      render :json => {"status": "updated"}  
    else
      redirect_to texts_url, notice: "Text details were successfully destroyed."
    end
  end

  private
  def set_text
    @text = Text.find(params[:id])
  end

  def text_params
    params.require(:text).permit(:content_id, :text_pages_folios_to, :text_pages_folios_from, :decoration, :title_pages_folios_to, :manuscript_title_orig, :manuscript_title_orig_transliteration, :manuscript_title_translation, :pages_folios_colophon, :colophon_orig, :colophon_transliteration, :colophon_translation, :notes, :transcriber_id, :version, :extent, :date_to, :date_from, :date_exact, :specific_date, :no_columns, :script, :manuscript_title_language_id, :colophon_pages_folios_to, :colophon_language_id, :writing_system_id, :notes_on_scribe)
  end

  def section_params(prms)
    prms.permit(:section_name, :incipit_language_id, :incipit_orig, :incipit_orig_transliteration, :incipit_translation, :explicit_language_id, :explicit_orig, :explicitorig_transliteration, :explicit_translation, :pages_folios_incipit, :pages_folios_explicit)
  end

  def build_language_references_for ids
    ids.each do |id|
      if id.present?
        @text.language_references.build(language_id: id)
      end
    end
  end

  def build_scribe_references_for ids, reference_type=""
    ids.each do |id|
      if id.present?
        @text.person_references.build(person_id: id, reference_type: reference_type)
      end
    end
  end
end
