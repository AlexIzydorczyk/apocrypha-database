class BookletsController < ApplicationController
  before_action :set_booklet, only: %i[ show edit update destroy ]

  # GET /booklets or /booklets.json
  def index
    @booklets = Booklet.all
  end

  # GET /booklets/1 or /booklets/1.json
  def show
  end

  # GET /booklets/new
  def new
    @booklet = Booklet.new
  end

  # GET /booklets/1/edit
  def edit
  end

  # POST /booklets or /booklets.json
  def create
    @booklet = Booklet.new(booklet_params)

    respond_to do |format|
      if @booklet.save
        format.html { redirect_to booklet_url(@booklet), notice: "Booklet was successfully created." }
        format.json { render :show, status: :created, location: @booklet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @booklet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /booklets/1 or /booklets/1.json
  def update
    respond_to do |format|
      if @booklet.update(booklet_params)
        format.html { redirect_to booklet_url(@booklet), notice: "Booklet was successfully updated." }
        format.json { render :show, status: :ok, location: @booklet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @booklet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /booklets/1 or /booklets/1.json
  def destroy
    @booklet.destroy

    respond_to do |format|
      format.html { redirect_to booklets_url, notice: "Booklet was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booklet
      @booklet = Booklet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def booklet_params
      params.require(:booklet).permit(:booklet_type, :manuscript_id)
    end
end
