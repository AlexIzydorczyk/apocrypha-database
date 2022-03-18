class ManuscriptsController < ApplicationController
  before_action :set_manuscript, only: %i[ show edit update destroy ]
  skip_before_action :authenticate_user!, only: %i[ index ]
  before_action :allow_for_editor, only: %i[ edit update destroy create ]

  def index
    @manuscripts = Manuscript.all
  end

  def show
  end

  def new
    @manuscript = Manuscript.new
    @languages = Language.all
    @language_references = @manuscript.language_references.build
    @content_types = Manuscript.where.not(content_type: "").pluck(:content_type)
  end

  def edit
    @languages = Language.all
    @language_references = @manuscript.language_references.build
    @content_types = Manuscript.where.not(content_type: "").pluck(:content_type)
    @modern_sources = ModernSource.all
    @scribe_reference = @manuscript.scribe_references.build
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

  def create_from_booklist
    @manuscript = Manuscript.new(manuscript_params)
    build_language_references_for params[:language_reference][:id] if params[:language_reference].present?

    if @manuscript.save
      booklist_reference = BooklistReference.create(record: @manuscript, booklist_section_id: params[:booklist_section_id])
      redirect_to edit_manuscript_path(@manuscript, old_path: params[:from])
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update

    if params[:language_reference].present?
      new_set = params[:language_reference][:id].filter{ |id| id.present? }.map{ |id| id.to_i }
      LanguageReference.where(record: @manuscript, language_id: @manuscript.languages.ids - new_set).destroy_all
      build_language_references_for new_set - @manuscript.languages.ids
    end

    if params[:correspondent_reference].present?
      new_set = params[:correspondent_reference][:id].filter{ |id| id.present? }.map{ |id| id.to_i }
      PersonReference.where(record: @manuscript, person_id: @manuscript.scribes.ids - new_set, reference_type: "correspondent").destroy_all
      build_scribe_references_for((new_set - @manuscript.correspondents.ids), "correspondent")
    else
      @manuscript.correspondent_references.destroy_all
    end

    if params[:transcriber_reference].present?
      new_set = params[:transcriber_reference][:id].filter{ |id| id.present? }.map{ |id| id.to_i }
      PersonReference.where(record: @manuscript, person_id: @manuscript.scribes.ids - new_set, reference_type: "transcriber").destroy_all
      build_scribe_references_for((new_set - @manuscript.transcribers.ids), "transcriber")
    else
      @manuscript.transcriber_references.destroy_all
    end

    if params[:compiler_reference].present?
      new_set = params[:compiler_reference][:id].filter{ |id| id.present? }.map{ |id| id.to_i }
      PersonReference.where(record: @manuscript, person_id: @manuscript.scribes.ids - new_set, reference_type: "compiler").destroy_all
      build_scribe_references_for((new_set - @manuscript.compilers.ids), "compiler")
    else
      @manuscript.compiler_references.destroy_all
    end

    if params[:person_reference].present?
      new_set = params[:person_reference][:id].filter{ |id| id.present? }.map{ |id| id.to_i }
      PersonReference.where(record: @manuscript, person_id: @manuscript.scribes.ids - new_set, reference_type: "scribe").destroy_all
      build_scribe_references_for((new_set - @manuscript.scribes.ids), "scribe")
    else
      @manuscript.scribe_references.destroy_all
    end
    
    if @manuscript.update(manuscript_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        if params[:old_path].present?
          redirect_to params[:old_path], notice: "Manuscript was successfully updated."
        else
          redirect_to manuscripts_url, notice: "Manuscript was successfully updated."
        end
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
    params.require(:manuscript).permit(:identifier, :census_no, :status, :institution_id, :shelfmark, :old_shelfmark, :material, :dimensions, :leaf_page_no, :date_from, :date_to, :content_type, :notes, :known_booklet_composition, :is_folios, :specific_date, :date_exact, :genesis_institution_id, :genesis_religious_order_id, :genesis_location_id, :origin_notes, :reproduction_online, languages_attributes: [:id])
  end

  def build_language_references_for ids
    ids.each do |id|
      if id.present?
        @manuscript.language_references.build(language_id: id)
      end
    end
  end

  def build_scribe_references_for ids, reference_type=""
    puts "reference type is".red
    puts reference_type
    puts ids
    ids.each do |id|
      if id.present?
        @manuscript.person_references.build(person_id: id, reference_type: reference_type)
      end
    end
  end

end
