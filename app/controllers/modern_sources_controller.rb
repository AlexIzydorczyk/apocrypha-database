class ModernSourcesController < ApplicationController
  before_action :set_modern_source, only: %i[ show edit update destroy ]

  def index
    @modern_sources = ModernSource.all
  end

  def show
  end

  def new
    @modern_source = ModernSource.new(source_type: 'book_chapter')
    @author_reference = @modern_source.author_references.build
    @editor_reference = @modern_source.editor_references.build
    @translator_reference = @modern_source.editor_references.build
    @modern_source.source_urls.build if @modern_source.source_urls.count < 1
  end

  def edit
    @author_reference = @modern_source.author_references.build
    @editor_reference = @modern_source.editor_references.build
    @translator_reference = @modern_source.editor_references.build
    @modern_source.source_urls.build if @modern_source.source_urls.count < 1
    @publishers = ModernSource.where.not(publisher: "").pluck(:publisher).uniq
    @editions = ModernSource.where.not(edition: "").pluck(:edition).uniq
    @document_types = (ModernSource.where.not(document_type: "").pluck(:document_type) + ["Book", "Journal Article", "Website"]).uniq
  end

  def create
    @modern_source = ModernSource.new(modern_source_params)
    build_person_references_for params[:language_reference][:id], 'author' if params[:language_reference].present?

    if @modern_source.save
      #redirect_to modern_sources_url, notice: "Modern source was successfully created."
      redirect_to edit_modern_source_path(@modern_source)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create_from_booklist
    @modern_source = ModernSource.new(modern_source_params)
    build_person_references_for params[:language_reference][:id], 'author' if params[:language_reference].present?

    if @modern_source.save
      BooklistSection.find(params[:booklist_section_id]).update({modern_source_id: @modern_source.id}) if params[:booklist_section_id].present?
      ModernSourceReference.create(modern_source_id: @modern_source.id, record: Booklist.find(params[:booklist_id])) if params[:booklist_id].present?
      redirect_to edit_modern_source_path(@modern_source, old_path: params[:from])
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create_from_text
    @modern_source = ModernSource.create
    ModernSourceReference.find(params[:modern_source_reference_id]).update(modern_source: @modern_source)
    redirect_to edit_modern_source_path(@modern_source, old_path: params[:from])
  end

  def create_from_manuscript
    @modern_source = ModernSource.create
    ModernSourceReference.find(params[:modern_source_reference_id]).update(modern_source: @modern_source)
    redirect_to edit_modern_source_path(@modern_source, old_path: params[:from])
  end

  def update
    if params[:author_reference].present?
      new_set = params[:author_reference][:id].filter{ |id| id.present? }.map{ |id| id.to_i }
      PersonReference.where(record: @modern_source, person_id: @modern_source.authors.ids - new_set).destroy_all
      build_person_references_for new_set - @modern_source.authors.ids, 'author'
    end

    if params[:editor_reference].present?
      new_set = params[:editor_reference][:id].filter{ |id| id.present? }.map{ |id| id.to_i }
      PersonReference.where(record: @modern_source, person_id: @modern_source.editors.ids - new_set).destroy_all
      build_person_references_for new_set - @modern_source.authors.ids, 'editor'
    end

    if params[:translator_reference].present?
      new_set = params[:translator_reference][:id].filter{ |id| id.present? }.map{ |id| id.to_i }
      PersonReference.where(record: @modern_source, person_id: @modern_source.translators.ids - new_set).destroy_all
      build_person_references_for new_set - @modern_source.authors.ids, 'translator'
    end

    if params[:source_urls].present?
      new_set = params[:source_urls][:urls].filter{ |url| url[:url].present? }.map{ |url| url[:url] }
      SourceUrl.where(modern_source_id: @modern_source.id).where.not(url: new_set).destroy_all
      (new_set - @modern_source.source_urls.map(&:url)).each{ |url| @modern_source.source_urls.build(url: url) }
      @modern_source.save
      params[:source_urls][:urls].each{ |source|
        @modern_source.source_urls.where(url: source[:url]).update_all(date_accessed: Date.parse(source[:date_accessed]))
      }
    end

    if @modern_source.update(modern_source_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
         if params[:old_path].present?
          redirect_to params[:old_path], notice: "Bibliography was successfully updated."
        else
          redirect_to modern_sources_url, notice: "Bibliography was successfully updated."
        end
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @modern_source.destroy
    redirect_to modern_sources_url, notice: "Modern source was successfully destroyed."
  end

  private
    def set_modern_source
      @modern_source = ModernSource.find(params[:id])
    end

    def modern_source_params
      params.require(:modern_source).permit(:publication_title_orig, :publication_title_transliteration, :publication_title_translation, :title_orig, :title_transliteration, :title_translation, :source_type, :num_volumes, :volume_no, :volume_title_orig, :volume_title_transliteration, :volume_title_translation, :part_no, :part_title_orig, :part_title_transliteration, :part_title_translation, :series_no, :series_title_orig, :series_title_transliteration, :series_title_translation, :edition, :publication_location_id, :publisher, :publication_creation_date, :shelfmark, :ISBN, :DOI, :author_type, :institution_id, :publication_title_language_id, :volume_title_language_id, :part_title_language_id, :series_title_language_id, :title_language_id, :pages_in_publication, :document_type, :date_accessed, :part_title_language_id, :original_publication_creation_date)
    end

    def build_person_references_for ids, reference_type
      ids.each do |id|
        if id.present?
          @modern_source.person_references.build(person_id: id, reference_type: reference_type)
        end
      end
    end
end
