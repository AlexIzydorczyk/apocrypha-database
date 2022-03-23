class BookletsController < ApplicationController
  before_action :set_booklet, only: %i[ show edit update destroy ]
  skip_before_action :authenticate_user!, only: %i[ index ]
  before_action :allow_for_editor, only: %i[ edit update destroy create sort ]

  def index
    @booklets = Booklet.all
  end

  def show
  end

  def new
    @booklet = Booklet.new(manuscript_id: params[:manuscript_id] || '')
    @content_types = Booklet.where.not(content_type: "").pluck(:content_type)
  end

  def edit
    @scribe_reference = @booklet.scribe_references.build
    @content_types = Booklet.where.not(content_type: "").pluck(:content_type)
  end

  def create
    @booklet = Booklet.new(booklet_params)

    if @booklet.save
      ChangeLog.create(user_id: current_user.id, record_type: 'Booklet', record_id: @booklet.id, controller_name: 'booklets', action_name: 'create')
      redirect_path = params[:in_manuscript] ? edit_manuscript_booklet_path(@booklet.manuscript, @booklet) : edit_booklet_path(@booklet)
      redirect_to redirect_path, notice: "Booklet was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if params[:person_reference].present?
      new_set = params[:person_reference][:id].filter{ |id| id.present? }.map{ |id| id.to_i }
      PersonReference.where(record: @booklet, person_id: @booklet.scribes.ids - new_set).destroy_all
      build_scribe_references_for new_set - @booklet.scribes.ids
    else
      @booklet.scribe_references.destroy_all
    end

    if @booklet.update(booklet_params)
      ChangeLog.create(user_id: current_user.id, record_type: 'Booklet', record_id: @booklet.id, controller_name: 'booklets', action_name: 'update')
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
    ChangeLog.create(user_id: current_user.id, record_type: 'Booklet', record_id: @booklet.id, controller_name: 'booklets', action_name: 'destroy')
    redirect_to booklets_url, notice: "Booklet was successfully destroyed."
  end

  def sort
    params[:booklet].each_with_index do |id, index|
      Booklet.where(id: id).update_all(booklet_no: index + 1)
    end
  end

  private

  def set_booklet
    @booklet = Booklet.find(params[:id])
  end

  def booklet_params
    params.require(:booklet).permit(:manuscript_id, :booklet_no, :pages_folios_from, :pages_folios_to, :date_from, :date_to, :specific_date, :genesis_location_id, :genesis_institution_id, :genesis_religious_order_id, :content_type, :date_exact, :origin_notes, person_references_attributes: [], texts_attributes: [])
  end

  def build_scribe_references_for ids
    ids.each do |id|
      if id.present?
        @booklet.scribe_references.build(person_id: id, reference_type: "scribe")
      end
    end
  end

end
