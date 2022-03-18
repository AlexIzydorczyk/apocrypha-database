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
    @modern_sources = ModernSource.all
  end

  def create
    @text = Text.new(text_params)
    build_language_references_for params[:language_reference][:id] if params[:language_reference].present?

    if @text.save
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

    params[:sections].each do |id, prms|
      Section.find(id).update(section_params(prms))
    end

    if @text.update(text_params)
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
    redirect_to texts_url, notice: "Text was successfully destroyed."
  end

  private
  def set_text
    @text = Text.find(params[:id])
  end

  def text_params
    params.require(:text).permit(:content_id, :text_pages_folios_to, :text_pages_folios_from, :decoration, :title_pages_folios_to, :manuscript_title_orig, :manuscript_title_orig_transliteration, :manuscript_title_translation, :pages_folios_colophon, :colophon_orig, :colophon_transliteration, :colophon_translation, :notes, :transcriber_id, :version, :extent, :date_to, :date_from, :date_exact, :specific_date, :no_columns, :script, :manuscript_title_language_id, :colophon_pages_folios_to, :colophon_language_id, :writing_system_id)
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
end
