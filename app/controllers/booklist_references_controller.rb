class BooklistReferencesController < ApplicationController
  before_action :set_booklist_reference, only: %i[ show edit update destroy ]

  def index
    @booklist_references = BooklistReference.all
  end

  def show
  end

  def new
    @booklist_reference = BooklistReference.new
  end

  def edit
  end

  def create
    @booklist_reference = BooklistReference.new(booklist_reference_params)

    if @booklist_reference.save
      redirect_to booklist_references_url, notice: "Booklist reference was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @booklist_reference.update(booklist_reference_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to booklist_references_url, notice: "Booklist reference was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @booklist_reference.destroy
    redirect_to booklist_references_url, notice: "Booklist reference was successfully destroyed."
  end

  private
    def set_booklist_reference
      @booklist_reference = BooklistReference.find(params[:id])
    end

    def booklist_reference_params
      params.require(:booklist_reference).permit(:booklist_id, :text_id, :relevant_text_booklist_orig, :relevant_text_booklist_orig_transliteration, :relevant_text_booklist_translation, :apocryphon_id)
    end
end
