class ApocryphaController < ApplicationController
  before_action :set_apocryphon, only: %i[ show edit update destroy ]

  def index
    @apocrypha = Apocryphon.all
  end

  def show
  end

  def new
    @apocryphon = Apocryphon.new
  end

  def edit
  end

  def create
    @apocryphon = Apocryphon.new(apocryphon_params)

    if @apocryphon.save
      redirect_to apocrypha_url, notice: "Apocryphon was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
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
end
