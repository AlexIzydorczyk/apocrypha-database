class BooklistSectionsController < ApplicationController
  before_action :set_booklist_section, only: %i[ show edit update destroy ]

  def index
    @booklist_sections = BooklistSection.all
  end

  def show
  end

  def new
    @booklist_section = BooklistSection.new
  end

  def edit
  end

  def create
    @booklist_section = BooklistSection.new(booklist_section_params)

    if @booklist_section.save
      #redirect_to booklist_sections_url, notice: "Booklist section was successfully created."
      redirect_to edit_booklist_url(@booklist_section.booklist), notice: "Booklist section was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @booklist_section.update(booklist_section_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to booklist_sections_url, notice: "Booklist section was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @booklist_section.destroy
    if request.xhr?
      render :json => {"status": "updated"}  
    else
      redirect_to booklist_sections_url, notice: "Booklist section was successfully destroyed."
    end
  end

  private
    def set_booklist_section
      @booklist_section = BooklistSection.find(params[:id])
    end

    def booklist_section_params
      params.require(:booklist_section).permit(:booklist_id, :sequence_no, :heading_orig, :heading_orig_transliteration, :heading_translation, :relevant_text_orig, :relevant_text_orig_transliteration, :relevant_text_translation, :manuscript_id, :modern_source_id, :page_ref, :notes)
    end
end
