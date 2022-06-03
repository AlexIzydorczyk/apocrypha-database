class BooklistsController < ApplicationController
  before_action :set_booklist, only: %i[ show edit update destroy ]
  skip_before_action :authenticate_user!, only: %i[ index ]
  before_action :allow_for_editor, only: %i[ edit update destroy create ]

  def index
    @booklists = Booklist.all.includes(:library_owner, :institution, :location, :modern_source_references, :modern_sources, :booklist_sections)
    if current_user.present?
      @initial_state = current_user.user_grid_states.find_by(record_type: "Booklist").try(:state).try(:to_json).try(:html_safe)
      @initial_filter = current_user.user_grid_states.find_by(record_type: "Booklist").try(:filters).try(:to_json).try(:html_safe)
    end
  end

  def show
    if request.xhr?
      render json: {booklist: @booklist}
    end
  end

  def new
    @booklist = Booklist.new
    @author_reference = @booklist.author_references.build
  end

  def edit
    @languages = Language.all
    @author_reference = @booklist.author_references.build
    @modern_sources = ModernSource.left_outer_joins([:authors, :institution]).order("people.last_name_vernacular", "institutions.name", "people.first_name_vernacular", "modern_sources.publication_title_orig", "modern_sources.title_orig").all.uniq
  end

  def create
    @booklist = Booklist.new(booklist_params)

    if @booklist.save
      ChangeLog.create(user_id: current_user.id, record_type: 'Booklist', record_id: @booklist.id, controller_name: 'booklist', action_name: 'create')
      #redirect_to booklists_url, notice: "Booklist was successfully created."
      redirect_to edit_booklist_path(@booklist)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if params[:author_reference].present?
      new_set = params[:author_reference][:id].filter{ |id| id.present? }.map{ |id| id.to_i }
      PersonReference.where(record: @booklist, person_id: @booklist.authors.ids - new_set).destroy_all
      build_person_references_for new_set - @booklist.authors.ids, 'author'
    elsif params[:in_grid].blank?
      @booklist.author_references.destroy_all
    end

    if @booklist.update(booklist_params)
      ChangeLog.create(user_id: current_user.id, record_type: 'Booklist', record_id: @booklist.id, controller_name: 'booklist', action_name: 'update')
      if request.xhr?
        render :json => {id: @booklist.id}  
      else
        redirect_to booklists_url, notice: "Booklist was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @booklist.destroy
    ChangeLog.create(user_id: current_user.id, record_type: 'Booklist', record_id: @booklist.id, controller_name: 'booklist', action_name: 'destroy')
    redirect_to booklists_url, notice: "Booklist was successfully destroyed."
  end

  private

  def set_booklist
    @booklist = Booklist.find(params[:id])
  end

  def booklist_params
    params.require(:booklist).permit(:booklist_type, :manuscript_source, :library_owner_id, :institution_id, :location_id, :religious_order_id, :scribe_id, :language_id, :title_orig, :title_orig_transliteration, :title_orig_translation, :chapter_orig, :chapter_orig_transliteration, :chapter_translation, :date_from, :date_to, :specific_date, :notes, :date_exact, :booklist_no)
  end

  def build_person_references_for ids, reference_type
    if ids.class == Array
      ids.each do |id|
        if id.present?
          @booklist.person_references.build(person_id: id, reference_type: reference_type)
        end
      end
    else
      @booklist.person_references.build(person_id: ids, reference_type: reference_type)
    end
  end

end
