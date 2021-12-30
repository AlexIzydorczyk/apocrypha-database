class ApocryphaController < ApplicationController
  before_action :set_apocryphon, only: %i[ show edit update destroy ]

  # GET /apocrypha or /apocrypha.json
  def index
    @apocrypha = Apocryphon.all
  end

  # GET /apocrypha/1 or /apocrypha/1.json
  def show
  end

  # GET /apocrypha/new
  def new
    @apocryphon = Apocryphon.new
  end

  # GET /apocrypha/1/edit
  def edit
  end

  # POST /apocrypha or /apocrypha.json
  def create
    @apocryphon = Apocryphon.new(apocryphon_params)

    respond_to do |format|
      if @apocryphon.save
        format.html { redirect_to apocryphon_url(@apocryphon), notice: "Apocryphon was successfully created." }
        format.json { render :show, status: :created, location: @apocryphon }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @apocryphon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /apocrypha/1 or /apocrypha/1.json
  def update
    respond_to do |format|
      if @apocryphon.update(apocryphon_params)
        format.html { redirect_to apocryphon_url(@apocryphon), notice: "Apocryphon was successfully updated." }
        format.json { render :show, status: :ok, location: @apocryphon }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @apocryphon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apocrypha/1 or /apocrypha/1.json
  def destroy
    @apocryphon.destroy

    respond_to do |format|
      format.html { redirect_to apocrypha_url, notice: "Apocryphon was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_apocryphon
      @apocryphon = Apocryphon.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def apocryphon_params
      params.require(:apocryphon).permit(:title)
    end
end
