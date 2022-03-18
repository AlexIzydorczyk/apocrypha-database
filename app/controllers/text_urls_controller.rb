class TextUrlsController < ApplicationController
  before_action :set_text_url, only: %i[ show edit update destroy ]
  skip_before_action :authenticate_user!, only: %i[ index ]
  before_action :allow_for_editor, only: %i[ edit update destroy create ]

  def index
    @text_urls = TextUrl.all
  end

  def show
  end

  def new
    @text_url = TextUrl.new
  end

  def edit
  end

  def create
    @text_url = TextUrl.new(text_url_params)

    if @text_url.save
      redirect_to text_urls_url, notice: "Text url was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @text_url.update(text_url_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to text_urls_url, notice: "Text url was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @text_url.destroy
    redirect_to text_urls_url, notice: "Text url was successfully destroyed."
  end

  private
    def set_text_url
      @text_url = TextUrl.find(params[:id])
    end

    def text_url_params
      params.require(:text_url).permit(:type, :text_id, :url)
    end
end
