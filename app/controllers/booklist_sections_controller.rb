class BooklistSectionsController < ApplicationController
  before_action :set_booklist_section, only: %i[ show edit update destroy ]
  #skip_before_action :authenticate_user!, only: %i[ index ]
  before_action :allow_for_editor, only: %i[ edit update destroy create ]

  def index
    @booklist_references = BooklistReference.all
    @booklist_sections_accounted = @booklist_references.map(&:booklist_section_id).uniq
    @booklists_accounted = @booklist_references.map{ |br| br.booklist_section.booklist_id}.uniq

    @booklist_sections = BooklistSection.where.not(id: @booklist_sections_accounted).all
    @booklists_accounted = (@booklists_accounted + @booklist_sections.map(&:booklist_id)).uniq

    @booklists = Booklist.where.not(id: @booklists_accounted).all

    @queries = {booklist_references: @booklist_references, booklist_sections: @booklist_sections, booklists: @booklists} 

    @new_booklist_reference = BooklistReference.new
    @new_booklist_section = BooklistSection.new
    @new_apocryphon = Apocryphon.new

    @grid_states = UserGridState.where(user_id: nil, record_type: "BooklistSection").order(:index)

    ugs = user_signed_in? && current_user.user_grid_states.exists?(record_type: "BooklistSection") ? current_user.user_grid_states.where(record_type: "BooklistSection").first : (UserGridState.exists?(record_type: "BooklistSection", is_default: true) ? UserGridState.where(record_type: "BooklistSection", is_default: true).first : nil)

    @initial_state = ugs.try(:state).try(:to_json).try(:html_safe)
    @initial_filter = ugs.try(:filters).try(:to_json).try(:html_safe)
  end

  def show
  end

  def new
    @booklist_section = BooklistSection.new
  end

  def edit
  end

  def create
    @booklist_section = BooklistSection.new(booklist_section_params)

    if @booklist_section.save
      ChangeLog.create(user_id: current_user.id, record_type: 'BooklistSection', record_id: @booklist_section.id, controller_name: 'booklist_section', action_name: 'create')
      #redirect_to booklist_sections_url, notice: "Booklist section was successfully created."
      redirect_to edit_booklist_url(@booklist_section.booklist), notice: "Booklist section was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @booklist_section.update(booklist_section_params)
      ChangeLog.create(user_id: current_user.id, record_type: 'BooklistSection', record_id: @booklist_section.id, controller_name: 'booklist_section', action_name: 'update')
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to booklist_sections_url, notice: "Booklist section was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @booklist_section.destroy
    ChangeLog.create(user_id: current_user.id, record_type: 'BooklistSection', record_id: @booklist_section.id, controller_name: 'booklist_section', action_name: 'destroy')
    if request.xhr?
      render :json => {"status": "updated"}  
    else
      redirect_to booklist_sections_url, notice: "Booklist section was successfully destroyed."
    end
  end

  private
    def set_booklist_section
      @booklist_section = BooklistSection.find(params[:id])
    end

    def booklist_section_params
      params.require(:booklist_section).permit(:booklist_id, :sequence_no, :heading_orig, :heading_orig_transliteration, :heading_translation, :relevant_text_orig, :relevant_text_orig_transliteration, :relevant_text_translation, :manuscript_id, :modern_source_id, :page_ref, :notes)
    end
end
