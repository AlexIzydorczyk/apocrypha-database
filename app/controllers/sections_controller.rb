class SectionsController < ApplicationController
  before_action :set_section, only: %i[ show edit update destroy ]
  skip_before_action :authenticate_user!, only: %i[ index ]
  before_action :allow_for_editor, only: %i[ edit update destroy create ]

 def index
    
    @sections = Section.joins(text: :content).all.order("sections.index asc, contents.sequence_no asc").includes(text: [:languages, :transcriber, :scribes, content: [:author, title: [:apocryphon], booklet: [:scribes, :genesis_location, :genesis_institution, :genesis_religious_order, :scribe_references, ownerships: [:person, :institution, :location, :religious_order], manuscript: [:reproduction_urls, :database_urls, :genesis_location, :genesis_institution, :genesis_religious_order, :scribe_references, :scribes, :language_references, :languages, :booklets, :modern_source_references, :modern_sources, :person_references, :correspondent_references, :correspondents, :transcriber_references, :transcribers, :compiler_references, :compilers, :contents, :booklist_sections, :institution, institution: [:location], ownerships: [:person, :institution, :location, :religious_order]]]]])
    
    texts_w_section = Section.all.map(&:text_id)
    @texts = Text.where.not(id: texts_w_section).all.includes(:languages, :transcriber, :scribes, content: [:author, title: [:apocryphon], booklet: [:scribes, :genesis_location, :genesis_institution, :genesis_religious_order, :scribe_references, ownerships: [:person, :institution, :location, :religious_order], manuscript: [:reproduction_urls, :database_urls, :genesis_location, :genesis_institution, :genesis_religious_order, :scribe_references, :scribes, :language_references, :languages, :booklets, :modern_source_references, :modern_sources, :person_references, :correspondent_references, :correspondents, :transcriber_references, :transcribers, :compiler_references, :compilers, :contents, :booklist_sections, :institution, institution: [:location], ownerships: [:person, :institution, :location, :religious_order]]]])

    contents_w_text = Text.all.map(&:content_id)
    @contents = Content.where.not(id: contents_w_text).all.order("sequence_no asc").includes(:author, title: [:apocryphon], booklet: [:scribes, :genesis_location, :genesis_institution, :genesis_religious_order, :scribe_references, ownerships: [:person, :institution, :location, :religious_order], manuscript: [:reproduction_urls, :database_urls, :genesis_location, :genesis_institution, :genesis_religious_order, :scribe_references, :scribes, :language_references, :languages, :booklets, :modern_source_references, :modern_sources, :person_references, :correspondent_references, :correspondents, :transcriber_references, :transcribers, :compiler_references, :compilers, :contents, :booklist_sections, :institution, institution: [:location], ownerships: [:person, :institution, :location, :religious_order]]])

    booklet_w_contents = Content.all.map(&:booklet_id)
    @booklets = Booklet.where.not(id: booklet_w_contents).all.includes(:scribes, :genesis_location, :genesis_institution, :genesis_religious_order, :scribe_references, ownerships: [:person, :institution, :location, :religious_order], manuscript: [:reproduction_urls, :database_urls, :genesis_location, :genesis_institution, :genesis_religious_order, :scribe_references, :scribes, :language_references, :languages, :booklets, :modern_source_references, :modern_sources, :person_references, :correspondent_references, :correspondents, :transcriber_references, :transcribers, :compiler_references, :compilers, :ownerships, :contents, :booklist_sections, :institution, institution: [:location], ownerships: [:person, :institution, :location, :religious_order]])

    manuscripts_w_booklets = Booklet.all.map(&:manuscript_id)
    manuscripts_w_contents = Content.all.map(&:manuscript_id)
    manuscripts_to_exclude = (manuscripts_w_booklets + manuscripts_w_contents).uniq
    @manuscripts = Manuscript.where.not(id: manuscripts_to_exclude).all.includes(:reproduction_urls, :database_urls, :genesis_location, :genesis_institution, :genesis_religious_order, :scribe_references, :scribes, :language_references, :languages, :booklets, :modern_source_references, :modern_sources, :person_references, :correspondent_references, :correspondents, :transcriber_references, :transcribers, :compiler_references, :compilers, :contents, :booklist_sections, :institution, institution: [:location], ownerships: [:person, :institution, :location, :religious_order])

    @queries = {sections: @sections, texts: @texts, contents: @contents, booklets: @booklets, manuscripts: @manuscripts} 
    @new_text = Text.new
    @new_section = Section.new
    @new_content = Content.new
    @new_booklet = Booklet.new
    @new_apocryphon = Apocryphon.new

    @grid_states = UserGridState.where(user_id: nil, record_type: "Section").order(:index)

    ugs = user_signed_in? && current_user.user_grid_states.exists?(record_type: "Section") ? current_user.user_grid_states.where(record_type: "Section").first : (UserGridState.exists?(record_type: "Section", is_default: true) ? UserGridState.where(record_type: "Section", is_default: true).first : nil)

    @initial_state = ugs.try(:state).try(:to_json).try(:html_safe)
    @initial_filter = ugs.try(:filters).try(:to_json).try(:html_safe)

  end

  def show
  end

  def new
    @section = Section.new
  end

  def edit
  end

  def create
    @section = Section.new(section_params)

    if @section.save
      ChangeLog.create(user_id: current_user.id, record_type: 'Section', record_id: @section.id, controller_name: 'section', action_name: 'create')
      redirect_url = @section.text.content.booklet.present? ? edit_manuscript_booklet_content_text_path(@section.text.content.booklet.manuscript, @section.text.content.booklet, @section.text.content, @section.text) : edit_manuscript_content_text_path(@section.text.content.manuscript, @section.text.content, @section.text)
      redirect_to redirect_url, notice: "Section was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @section.update(section_params)
      ChangeLog.create(user_id: current_user.id, record_type: 'Section', record_id: @section.id, controller_name: 'section', action_name: 'update')
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to sections_url, notice: "Section was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @section.destroy
    ChangeLog.create(user_id: current_user.id, record_type: 'Section', record_id: @section.id, controller_name: 'section', action_name: 'destroy')
    redirect_to sections_url, notice: "Section was successfully destroyed." unless request.xhr?
  end

  private
    def set_section
      @section = Section.find(params[:id])
    end

    def section_params
      params.require(:section).permit(:text_id, :section_name, :pages_folios_incipit, :incipit_orig, :incipit_orig_transliteration, :incipit_translation, :pages_folios_explicit, :explicit_orig, :explicitorig_transliteration, :explicit_translation)
    end
end
