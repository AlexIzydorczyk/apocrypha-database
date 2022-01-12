class ReligiousOrdersController < ApplicationController
  before_action :set_religious_order, only: %i[ show edit update destroy ]

  def index
    @religious_orders = ReligiousOrder.all
  end

  def show
  end

  def new
    @religious_order = ReligiousOrder.new
  end

  def edit
  end

  def create
    @religious_order = ReligiousOrder.new(religious_order_params)

    if @religious_order.save
      redirect_to religious_orders_url, notice: "Religious order was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @religious_order.update(religious_order_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to religious_orders_url, notice: "Religious order was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @religious_order.destroy
    redirect_to religious_orders_url, notice: "Religious order was successfully destroyed."
  end

  private
    def set_religious_order
      @religious_order = ReligiousOrder.find(params[:id])
    end

    def religious_order_params
      params.require(:religious_order).permit(:order_name)
    end
end
