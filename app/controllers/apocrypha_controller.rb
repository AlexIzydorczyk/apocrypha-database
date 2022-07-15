class ApocryphaController < ApplicationController
  before_action :set_apocryphon, only: %i[ show edit update destroy ]
  skip_before_action :authenticate_user!, only: %i[ index ]
  before_action :allow_for_editor, only: %i[ edit update destroy create create_from_booklist ]

  def index
    @apocrypha = Apocryphon.all.includes(:languages, :titles, :language_references)
    if current_user.present?
      @initial_state = current_user.user_grid_states.find_by(record_type: "Apocryphon").try(:state).try(:to_json).try(:html_safe)
      @initial_filter = current_user.user_grid_states.find_by(record_type: "Apocryphon").try(:filters).try(:to_json).try(:html_safe)
    end
  end

  def show
  end

  def new
    @apocryphon = Apocryphon.new
    @languages = Language.all
    @language_references = @apocryphon.language_references.build
  end

  def edit
    @languages = Language.all
    @language_references = @apocryphon.language_references.build
    @apocryphon_titles = Title.where(apocryphon_id: @apocryphon.id).all
    @english_titles = @apocryphon_titles.where(language_id: helpers.english_id).all
    @latin_titles = @apocryphon_titles.where(language_id: helpers.latin_id).all
    @other_english_titles = @english_titles.where.not(id: @apocryphon.main_english_title_id).all
    @other_latin_titles = @latin_titles.where.not(id: @apocryphon.main_latin_title_id).all
    @list_of_languages = @apocryphon.languages_list
  end

  def create
    @apocryphon = Apocryphon.new(apocryphon_params)
    build_language_references_for params[:language_reference][:id] if params[:language_reference].present?

    if params[:parent_type].present? && params[:parent_id].present? && @apocryphon.content_id.blank?
      parent = params[:parent_type].constantize.find(params[:parent_id])
      c = parent.contents.create
      @apocryphon.content_id = c.id
    end

    if @apocryphon.save
      ChangeLog.create(user_id: current_user.id, record_type: 'Apocryphon', record_id: @apocryphon.id, controller_name: 'apocryphon', action_name: 'create')
      #redirect_to apocrypha_url, notice: "Apocryphon was successfully created."
      redirect_to edit_apocryphon_path(@apocryphon, old_path: params[:from])
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create_from_booklist
    @apocryphon = Apocryphon.new(apocryphon_params)
    build_language_references_for params[:language_reference][:id] if params[:language_reference].present?

    if @apocryphon.save
      ChangeLog.create(user_id: current_user.id, record_type: 'Apocryphon', record_id: @apocryphon.id, controller_name: 'apocryphon', action_name: 'create_from_booklist')
      puts 'from is'.red
      puts params[:from]
      booklist_reference = BooklistReference.create(record: @apocryphon, booklist_section_id: params[:booklist_section_id])
      redirect_to edit_apocryphon_path(@apocryphon, old_path: params[:from])
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if params[:language_reference]
      new_set = params[:language_reference][:id].filter{ |id| id.present? }.map{ |id| id.to_i }
      LanguageReference.where(record: @apocryphon, language_id: @apocryphon.languages.ids - new_set).destroy_all
      build_language_references_for new_set - @apocryphon.languages.ids
    end

    if @apocryphon.update(apocryphon_params)
      ChangeLog.create(user_id: current_user.id, record_type: 'Apocryphon', record_id: @apocryphon.id, controller_name: 'apocryphon', action_name: 'update')
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        if params[:old_path].present?
          redirect_to params[:old_path], notice: "Apocryphon was successfully updated."
        else
          redirect_to apocrypha_url, notice: "Apocryphon was successfully updated."
        end
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @apocryphon.destroy
    ChangeLog.create(user_id: current_user.id, record_type: 'Apocryphon', record_id: @apocryphon.id, controller_name: 'apocryphon', action_name: 'destroy')
    redirect_to apocrypha_url, notice: "Apocryphon was successfully destroyed."
  end

  private

  def set_apocryphon
    @apocryphon = Apocryphon.find(params[:id])
  end

  def apocryphon_params
    params.require(:apocryphon).permit(:apocryphon_no, :cant_no, :bhl_no, :bhg_no, :bho_no, :e_clavis_no, :e_clavis_link, :english_abbreviation, :latin_abbreviation, :main_latin_title_id, :main_english_title_id, :content_id, :notes)
  end

  def build_language_references_for ids
    ids.each do |id|
      if id.present?
        @apocryphon.language_references.build(language_id: id)
      end
    end
  end
end
