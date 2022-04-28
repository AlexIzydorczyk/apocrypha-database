class BooklistsController < ApplicationController
  before_action :set_booklist, only: %i[ show edit update destroy ]
  skip_before_action :authenticate_user!, only: %i[ index ]
  before_action :allow_for_editor, only: %i[ edit update destroy create ]

  def index
    @booklists = Booklist.all.includes(:library_owner, :institution, :location, :modern_source_references, :modern_sources, :booklist_sections)
  end

  def show
    if request.xhr?
      render json: {booklist: @booklist}
    end
  end

  def new
    @booklist = Booklist.new
  end

  def edit
    @languages = Language.all
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

end
