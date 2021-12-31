class ProvenancesController < ApplicationController
  before_action :set_provenance, only: %i[ show edit update destroy ]

  # GET /provenances or /provenances.json
  def index
    @provenances = Provenance.all
  end

  # GET /provenances/1 or /provenances/1.json
  def show
  end

  # GET /provenances/new
  def new
    @provenance = Provenance.new
  end

  # GET /provenances/1/edit
  def edit
  end

  # POST /provenances or /provenances.json
  def create
    @provenance = Provenance.new(provenance_params)

    respond_to do |format|
      if @provenance.save
        format.html { redirect_to provenance_url(@provenance), notice: "Provenance was successfully created." }
        format.json { render :show, status: :created, location: @provenance }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @provenance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /provenances/1 or /provenances/1.json
  def update
    respond_to do |format|
      if @provenance.update(provenance_params)
        format.html { redirect_to provenance_url(@provenance), notice: "Provenance was successfully updated." }
        format.json { render :show, status: :ok, location: @provenance }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @provenance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /provenances/1 or /provenances/1.json
  def destroy
    @provenance.destroy

    respond_to do |format|
      format.html { redirect_to provenances_url, notice: "Provenance was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_provenance
      @provenance = Provenance.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def provenance_params
      params.require(:provenance).permit(:booklet_id, :person, :institution, :location, :religious_order, :diocese, :region, :owned_from, :owned_to, :specific_date, :notes)
    end
end
