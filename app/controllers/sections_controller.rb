class SectionsController < ApplicationController
  before_action :set_section, only: %i[ show edit update destroy ]
  # skip_before_action :authenticate_user!, only: %i[ index ]
  before_action :allow_for_editor, only: %i[ index edit update destroy create ]

  def index
    @sections = Section.all.includes(text: [content: [booklet: :manuscript]])
    @texts = Text.all.where.not(id: @sections.map(&:text_id)).includes(content: [booklet: :manuscript])
    @contents = Content.all.where.not(id: @texts.map(&:content_id)).includes(booklet: :manuscript)
    @booklets = Booklet.all.where.not(id: @contents.map(&:booklet_id)).includes(:manuscript)
    @manuscripts = Manuscript.where.not(id: @contents.map(&:manuscript_id)+@booklets.map(&:manuscript_id))

    @queries = {sections: @sections, texts: @texts, contents: @contents, booklets: @booklets, manuscripts: @manuscripts} 
    @new_text = Text.new
    @new_section = Section.new
    @new_content = Content.new
    @new_booklet = Booklet.new
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
