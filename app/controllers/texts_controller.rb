class TextsController < ApplicationController
  before_action :set_text, only: %i[ show edit update destroy ]

  def index
    @texts = Text.all
  end

  def show
  end

  def new
    @text = Text.new
  end

  def edit
  end

  def create
    @text = Text.new(text_params)

    if @text.save
      content_parent = @text.content.try(:parent)
      if content_parent.class == Manuscript
        redirect_to edit_manuscript_content_text_path(content_parent, @text.content, @text)
      elsif content_parent.class == Booklet
        redirect_to edit_manuscript_booklet_content_text_path(content_parent.manuscript, content_parent, @text.content, @text)
      else
        redirect_to texts_url, notice: "Text was successfully created."
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @text.update(text_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to texts_url, notice: "Text was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @text.destroy
    redirect_to texts_url, notice: "Text was successfully destroyed."
  end

  private
    def set_text
      @text = Text.find(params[:id])
    end

    def text_params
      params.require(:text).permit(:content_id, :text_pages_folios, :decoration, :title_folios_pages, :manuscript_title_orig, :manuscript_title_orig_transliteration, :manuscript_title_translation, :pages_folios_colophon, :colophon_orig, :colophon_transliteration, :colophon_translation, :notes, :transcriber_id, :version, :extent)
    end
end
