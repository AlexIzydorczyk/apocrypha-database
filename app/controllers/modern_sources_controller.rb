class ModernSourcesController < ApplicationController
  before_action :set_modern_source, only: %i[ show edit update destroy ]

  def index
    @modern_sources = ModernSource.all
  end

  def show
  end

  def new
    @modern_source = ModernSource.new
    @author_reference = @modern_source.person_references.build
    @editor_reference = @modern_source.editor_references.build
    @translator_reference = @modern_source.editor_references.build
    @modern_source.source_urls.build if @modern_source.source_urls.count < 1
  end

  def edit
    @author_reference = @modern_source.person_references.build
    @editor_reference = @modern_source.editor_references.build
    @translator_reference = @modern_source.editor_references.build
    @modern_source.source_urls.build if @modern_source.source_urls.count < 1
  end

  def create
    @modern_source = ModernSource.new(modern_source_params)

    if @modern_source.save
      redirect_to modern_sources_url, notice: "Modern source was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @modern_source.update(modern_source_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to modern_sources_url, notice: "Modern source was successfully updated."
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
      params.require(:modern_source).permit(:publication_title_orig, :publication_title_transliteration, :publication_title_translation, :title_orig, :title_transliteration, :title_translation, :source_type, :num_volumes, :volume_no, :volume_title_orig, :volume_title_transliteration, :volume_title_translation, :part_no, :part_title_orig, :part_title_transliteration, :part_title_translation, :series_no, :series_title_orig, :series_title_transliteration, :series_title_translation, :edition, :publication_location_id, :publisher, :publication_creation_date, :shelfmark, :ISBN, :DOI, :language_id, :author_type, :institution_id)
    end
end
