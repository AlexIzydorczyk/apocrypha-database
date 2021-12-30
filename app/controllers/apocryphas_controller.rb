class ApocryphasController < ApplicationController
  before_action :set_apocrypha, only: %i[ show edit update destroy ]

  # GET /apocryphas or /apocryphas.json
  def index
    @apocryphas = Apocrypha.all
  end

  # GET /apocryphas/1 or /apocryphas/1.json
  def show
  end

  # GET /apocryphas/new
  def new
    @apocrypha = Apocrypha.new
  end

  # GET /apocryphas/1/edit
  def edit
  end

  # POST /apocryphas or /apocryphas.json
  def create
    @apocrypha = Apocrypha.new(apocrypha_params)

    respond_to do |format|
      if @apocrypha.save
        format.html { redirect_to apocrypha_url(@apocrypha), notice: "Apocrypha was successfully created." }
        format.json { render :show, status: :created, location: @apocrypha }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @apocrypha.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /apocryphas/1 or /apocryphas/1.json
  def update
    respond_to do |format|
      if @apocrypha.update(apocrypha_params)
        format.html { redirect_to apocrypha_url(@apocrypha), notice: "Apocrypha was successfully updated." }
        format.json { render :show, status: :ok, location: @apocrypha }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @apocrypha.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apocryphas/1 or /apocryphas/1.json
  def destroy
    @apocrypha.destroy

    respond_to do |format|
      format.html { redirect_to apocryphas_url, notice: "Apocrypha was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_apocrypha
      @apocrypha = Apocrypha.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def apocrypha_params
      params.require(:apocrypha).permit(:title)
    end
end
