class ApocryphaController < ApplicationController
  before_action :set_apocryphon, only: %i[ show edit update destroy ]

  def index
    @apocrypha = Apocryphon.all
  end

  def show
  end

  def new
    @apocryphon = Apocryphon.new
    @languages = Language.all
    @language_references = @apocryphon.language_references.build
  end

  def edit
    @languages = Language.all
    @language_references = @apocryphon.language_references.build
    @titles = Title.where(apocryphon_id: @apocryphon.id)
  end

  def create
    @apocryphon = Apocryphon.new(apocryphon_params)
    build_language_references_for params[:language_reference][:id] if params[:language_reference].present?

    if @apocryphon.save
      #redirect_to apocrypha_url, notice: "Apocryphon was successfully created."
      redirect_to edit_apocryphon_path(@apocryphon)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    new_set = params[:language_reference][:id].filter{ |id| id.present? }.map{ |id| id.to_i }
    LanguageReference.where(record: @apocryphon, language_id: @apocryphon.languages.ids - new_set).destroy_all
    build_language_references_for new_set - @apocryphon.languages.ids

    if @apocryphon.update(apocryphon_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to apocrypha_url, notice: "Apocryphon was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @apocryphon.destroy
    redirect_to apocrypha_url, notice: "Apocryphon was successfully destroyed."
  end

  private

  def set_apocryphon
    @apocryphon = Apocryphon.find(params[:id])
  end

  def apocryphon_params
    params.require(:apocryphon).permit(:apocryphon_no, :cant_no, :bhl_no, :bhg_no, :bho_no, :e_clavis_no, :e_clavis_link)
  end

  def build_language_references_for ids
    ids.each do |id|
      if id.present?
        @apocryphon.language_references.build(language_id: id)
      end
    end
  end
end
