class ManuscriptBooklistsController < ApplicationController
  before_action :set_manuscript_booklist, only: %i[ show edit update destroy ]

  def index
    @manuscript_booklists = ManuscriptBooklist.all
  end

  def show
  end

  def new
    @manuscript_booklist = ManuscriptBooklist.new
  end

  def edit
  end

  def create
    @manuscript_booklist = ManuscriptBooklist.create(manuscript_booklist_params)
    render :json => { new_url: "", id: @manuscript_booklist.id }
  end

  def update
    if @manuscript_booklist.update(manuscript_booklist_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to manuscript_booklists_url, notice: "Manuscript booklist was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @manuscript_booklist.destroy
    render :json => {"status": "updated"}  
  end

  private
    def set_manuscript_booklist
      @manuscript_booklist = ManuscriptBooklist.find(params[:id])
    end

    def manuscript_booklist_params
      params.require(:manuscript_booklist).permit(:manuscript_id, :booklist_id)
    end
end
