class BookletsController < ApplicationController
  before_action :set_booklet, only: %i[ show edit update destroy ]

  def index
    @booklets = Booklet.all
  end

  def show
  end

  def new
    @booklet = Booklet.new
  end

  def edit
  end

  def create
    @booklet = Booklet.new(booklet_params)

    if @booklet.save
      redirect_to booklets_url, notice: "Booklet was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @booklet.update(booklet_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to booklets_url, notice: "Booklet was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @booklet.destroy
    redirect_to booklets_url, notice: "Booklet was successfully destroyed."
  end

  private
    def set_booklet
      @booklet = Booklet.find(params[:id])
    end

    def booklet_params
      params.require(:booklet).permit(:manuscript_id, :booklet_no, :pages_folios, :date_from, :date_to, :specific_date, :genesis_location_id, :genesis_institution_id, :genesis_religious_order_id, :content_type)
    end
end
