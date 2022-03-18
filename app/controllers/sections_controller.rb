class SectionsController < ApplicationController
  before_action :set_section, only: %i[ show edit update destroy ]
  # skip_before_action :authenticate_user!, only: %i[ index ]
  before_action :allow_for_editor, only: %i[ index edit update destroy create ]

  def index
    @sections = Section.all
  end

  def show
  end

  def new
    @section = Section.new
  end

  def edit
  end

  def create
    @section = Section.new(section_params)

    if @section.save
      redirect_to edit_manuscript_booklet_content_text_path(@section.text.content.booklet.manuscript, @section.text.content.booklet, @section.text.content, @section.text), notice: "Section was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @section.update(section_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to sections_url, notice: "Section was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @section.destroy
    redirect_to sections_url, notice: "Section was successfully destroyed."
  end

  private
    def set_section
      @section = Section.find(params[:id])
    end

    def section_params
      params.require(:section).permit(:text_id, :section_name, :pages_folios_incipit, :incipit_orig, :incipit_orig_transliteration, :incipit_translation, :pages_folios_explicit, :explicit_orig, :explicitorig_transliteration, :explicit_translation)
    end
end
