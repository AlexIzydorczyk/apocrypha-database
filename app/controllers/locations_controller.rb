class LocationsController < ApplicationController
  before_action :set_location, only: %i[ show edit update destroy ]

  def index
    @locations = Location.all
  end

  def show
  end

  def new
    @location = Location.new
  end

  def edit
  end

  def create
    @location = Location.new(location_params)

    if @location.save
      redirect_to locations_url, notice: "Location was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @location.update(location_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to locations_url, notice: "Location was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @location.destroy
    redirect_to locations_url, notice: "Location was successfully destroyed."
  end

  private
    def set_location
      @location = Location.find(params[:id])
    end

    def location_params
      params.require(:location).permit(:country, :city_english, :city_orig, :city_translilteration, :region_english, :region_orig, :region_transliteration, :diocese_english, :diocese_orig, :diocese_transliteration, :longitude, :latitude)
    end
end
