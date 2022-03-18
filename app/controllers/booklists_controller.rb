class BooklistsController < ApplicationController
  before_action :set_booklist, only: %i[ show edit update destroy ]
  skip_before_action :authenticate_user!, only: %i[ index ]
  before_action :allow_for_editor, only: %i[ edit update destroy create ]

  def index
    @booklists = Booklist.all
  end

  def show
  end

  def new
    @booklist = Booklist.new
  end

  def edit
    @languages = Language.all
    @modern_sources = ModernSource.where(source_type: "handwritten_document")
  end

  def create
    @booklist = Booklist.new(booklist_params)

    if @booklist.save
      #redirect_to booklists_url, notice: "Booklist was successfully created."
      redirect_to edit_booklist_path(@booklist)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @booklist.update(booklist_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to booklists_url, notice: "Booklist was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @booklist.destroy
    redirect_to booklists_url, notice: "Booklist was successfully destroyed."
  end

  private

  def set_booklist
    @booklist = Booklist.find(params[:id])
  end

  def booklist_params
    params.require(:booklist).permit(:booklist_type, :manuscript_source, :library_owner_id, :institution_id, :location_id, :religious_order_id, :scribe_id, :language_id, :title_orig, :title_orig_transliteration, :title_orig_translation, :chapter_orig, :chapter_orig_transliteration, :chapter_translation, :date_from, :date_to, :specific_date, :notes, :date_exact, :booklist_no)
  end

end
