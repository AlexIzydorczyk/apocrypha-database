class SourceUrlsController < ApplicationController
  before_action :set_source_url, only: %i[ show edit update destroy ]

  def index
    @source_urls = SourceUrl.all
  end

  def show
  end

  def new
    @source_url = SourceUrl.new
  end

  def edit
  end

  def create
    @source_url = SourceUrl.new(source_url_params)

    if @source_url.save
      redirect_to source_urls_url, notice: "Source url was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @source_url.update(source_url_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to source_urls_url, notice: "Source url was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @source_url.destroy
    redirect_to source_urls_url, notice: "Source url was successfully destroyed."
  end

  private
    def set_source_url
      @source_url = SourceUrl.find(params[:id])
    end

    def source_url_params
      params.require(:source_url).permit(:modern_source_id, :url)
    end
end
