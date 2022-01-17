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
  end

  def create
    @content = Content.new(content_params)

    if @content.save
      redirect_to contents_url, notice: "Content was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @content.update(content_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to contents_url, notice: "Content was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @content.destroy
    redirect_to contents_url, notice: "Content was successfully destroyed."
  end

  private
    def set_content
      @content = Content.find(params[:id])
    end

    def content_params
      params.require(:content).permit(:booklet_id, :sequence_no, :title_id, :author_id, :manuscript_id)
    end
end
