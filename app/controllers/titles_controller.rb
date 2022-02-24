class TitlesController < ApplicationController
  before_action :set_title, only: %i[ show edit update destroy ]

  def index
    @titles = Title.all
  end

  def show
  end

  def new
    @title = Title.new
  end

  def edit
  end

  def create
    @title = Title.new(title_params)

    if @title.save
      if request.xhr?
        puts 'here1'.red
        if @title.apocryphon_id.present? && params[:title][:is_standard] == "true" && @title.try(:language_id) == helpers.english_id
          puts 'here2'.blue
          @title.apocryphon.update(main_english_title_id: @title.id)
        elsif @title.apocryphon_id.present? && params[:title][:is_standard] == "true" &&  @title.try(:language_id) == helpers.latin_id
          puts 'here2'.green
          @title.apocryphon.update(main_latin_title_id: @title.id)
        end
        puts 'here3'.yellow
        render :json => {"status": "updated"}  
      else
        redirect_path = @title.apocryphon_id.present? ? edit_apocryphon_path(@title.apocryphon_id) : titles_path
        redirect_to redirect_path, notice: "Title was successfully created."
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @title.update(title_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to titles_url, notice: "Title was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @title.destroy
    if request.xhr?
      render :json => {"status": "updated"}  
    else
      redirect_to titles_url, notice: "Title was successfully destroyed."
    end
  end

  private
    def set_title
      @title = Title.find(params[:id])
    end

    def title_params
      params.require(:title).permit(:apocryphon_id, :title_orig, :title_orig_transliteration, :title_translation, :language_id, :abbreviation)
    end
end
