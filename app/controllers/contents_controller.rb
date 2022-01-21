class ContentsController < ApplicationController
  before_action :set_content, only: %i[ show edit update destroy ]

  def index
    @contents = Content.all
  end

  def show
  end

  def new
    @content = Content.new
  end

  def edit
    @content.update(has_details: true) unless @content.has_details
  end

  def create
    @content = Content.new(content_params)

    if @content.save
      # render :json => { new_url: ownership_path(@ownership) }
      # redirect_to contents_url, notice: "Content was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @content.update(content_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_path = params[:moved_to_booklet] ? edit_manuscript_path(@content.booklet.manuscript) : contents_path
        notice = params[:moved_to_booklet] ? "Content was successfully moved to booklet." : "Content was successfully updated."
        redirect_to redirect_path, notice: notice
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @content.destroy
    redirect_to contents_url, notice: "Content was successfully destroyed."
  end

  def sort
    params[:content].each_with_index do |id, index|
      Content.where(id: id).update_all(sequence_no: index + 1)
    end
  end

  private
    def set_content
      @content = Content.find(params[:id])
    end

    def content_params
      params.require(:content).permit(:booklet_id, :sequence_no, :title_id, :author_id, :manuscript_id)
    end
end
