class ReligiousOrdersController < ApplicationController
  before_action :set_religious_order, only: %i[ show edit update destroy ]
  skip_before_action :authenticate_user!, only: %i[ index ]
  before_action :allow_for_editor, only: %i[ edit update destroy create ]

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
    saved = @religious_order.save
    if params[:booklet_id].present?
      Booklet.find(params[:booklet_id]).update(genesis_religious_order_id: @religious_order.id)
    elsif params[:ownership_id].present?
      Ownership.find(params[:ownership_id]).update(religious_order_id: @religious_order.id)
    elsif params[:booklist_id].present?
      Booklist.find(params[:booklist_id]).update(religious_order: @religious_order)
    end
    ChangeLog.create(user_id: current_user.id, record_type: 'ReligiousOrder', record_id: @religious_order.id, controller_name: 'religious_order', action_name: 'create')
    if saved && !request.xhr?
      # redirect_path = params[:booklet_id].present? ? edit_manuscript_booklet_path(Booklet.find(params[:booklet_id]).manuscript, params[:booklet_id]) : religious_orders_path
      # redirect_to redirect_path, notice: "Religious order was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @religious_order.update(religious_order_params)
      ChangeLog.create(user_id: current_user.id, record_type: 'ReligiousOrder', record_id: @religious_order.id, controller_name: 'religious_order', action_name: 'update')
      if request.xhr?
        render json: {status: "updated"}  
      else
        redirect_to religious_orders_url, notice: "Religious order was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      @religious_order.destroy
      ChangeLog.create(user_id: current_user.id, record_type: 'ReligiousOrder', record_id: @religious_order.id, controller_name: 'religious_order', action_name: 'destroy')
      redirect_to religious_orders_url, notice: "Religious order was successfully destroyed."
    rescue StandardError => e
      redirect_to religious_orders_url, alert: "Object could not be deleted because it's being used somewhere else in the system"
    end
  end

  private
    def set_religious_order
      @religious_order = ReligiousOrder.find(params[:id])
    end

    def religious_order_params
      params.require(:religious_order).permit(:order_name)
    end
end
