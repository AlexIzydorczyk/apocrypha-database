class BookletBooklistsController < ApplicationController
  before_action :set_booklet_booklist, only: %i[ show edit update destroy ]

  def index
    @booklet_booklists = BookletBooklist.all
  end

  def show
  end

  def new
    @booklet_booklist = BookletBooklist.new
  end

  def edit
  end

  def create
    @booklet_booklist = BookletBooklist.create(booklet_booklist_params)
    render :json => { new_url: "", id: @booklet_booklist.id }
  end

  def update
    if @booklet_booklist.update(booklet_booklist_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to booklet_booklists_url, notice: "Booklet booklist was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @booklet_booklist.destroy
    render :json => {"status": "updated"}  
  end

  private
    def set_booklet_booklist
      @booklet_booklist = BookletBooklist.find(params[:id])
    end

    def booklet_booklist_params
      params.require(:booklet_booklist).permit(:booklet_id, :booklist_id)
    end
end
