class InstitutionalAffiliationsController < ApplicationController
  before_action :set_institutional_affiliation, only: %i[ show edit update destroy ]

  def index
    @institutional_affiliations = InstitutionalAffiliation.all
  end

  def show
  end

  def new
    @institutional_affiliation = InstitutionalAffiliation.new
  end

  def edit
  end

  def create
    @institutional_affiliation = InstitutionalAffiliation.new(institutional_affiliation_params)

    if @institutional_affiliation.save
      redirect_to institutional_affiliations_url, notice: "Institutional affiliation was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @institutional_affiliation.update(institutional_affiliation_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to institutional_affiliations_url, notice: "Institutional affiliation was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @institutional_affiliation.destroy
    redirect_to institutional_affiliations_url, notice: "Institutional affiliation was successfully destroyed."
  end

  private
    def set_institutional_affiliation
      @institutional_affiliation = InstitutionalAffiliation.find(params[:id])
    end

    def institutional_affiliation_params
      params.require(:institutional_affiliation).permit(:institution_id, :religious_order_id, :start_date, :end_date)
    end
end
