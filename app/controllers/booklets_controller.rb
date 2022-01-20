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
    @content_types = Booklet.all.pluck(:content_type).uniq.select{ |c| c.present? }.map{ |c| {value: c, text: c} }
    @scribe_reference = PersonReference.new(record_type: "Booklet", record_id: @booklet.id)
    @scribes = Person.all
    @religious_orders = ReligiousOrder.all
    @institutions = Institution.all
    @locations = Location.all
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
      params.require(:booklet).permit(:manuscript_id, :booklet_no, :pages_folios_from, :pages_folios_to, :date_from, :date_to, :specific_date, :genesis_location_id, :genesis_institution_id, :genesis_religious_order_id, :content_type)
    end
end
