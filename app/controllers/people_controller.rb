class PeopleController < ApplicationController
  before_action :set_person, only: %i[ show edit update destroy ]
  skip_before_action :authenticate_user!, only: %i[ index ]
  before_action :allow_for_editor, only: %i[ edit update destroy create ]

  def index
    @people = Person.all
  end

  def show
  end

  def new
    @person = Person.new
  end

  def edit
  end

  def create
    @person = Person.new(person_params)
    saved = @person.save
    if params[:booklet_id].present?
      PersonReference.create(record: Booklet.find(params[:booklet_id]), person: @person, reference_type: params[:reference_type])
    elsif params[:ownership_id].present?
      Ownership.find(params[:ownership_id]).update(person_id: @person.id)
    elsif params[:content_id].present?
      Content.find(params[:content_id]).update(author_id: @person.id)
    elsif params[:modern_source_id].present?
      PersonReference.create(record: ModernSource.find(params[:modern_source_id]), person: @person, reference_type: params[:reference_type])
    elsif params[:manuscript_id].present?
      PersonReference.create(record: Manuscript.find(params[:manuscript_id]), person: @person, reference_type: params[:reference_type])
    elsif params[:booklist_id].present?
      b = Booklist.find(params[:booklist_id])
      b[params[:db_field]] = @person.id
      b.save
    end
    ChangeLog.create(user_id: current_user.id, record_type: 'Person', record_id: @person.id, controller_name: 'person', action_name: 'create')
    if saved && !request.xhr?
      # redirect_path = params[:booklet_id].present? ? edit_manuscript_booklet_path(Booklet.find(params[:booklet_id]).manuscript, params[:booklet_id]) : people_path
      # redirect_to redirect_path, notice: "Person was successfully created."
    elsif !request.xhr?
      render :new, status: :unprocessable_entity
    end
  end


  def update
    if @person.update(person_params)
      ChangeLog.create(user_id: current_user.id, record_type: 'Person', record_id: @person.id, controller_name: 'person', action_name: 'update')
      if request.xhr?
        render :json => {"status": "updated"}
        elsez
        redirect_to people_url, notice: "Person was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      @person.destroy
      ChangeLog.create(user_id: current_user.id, record_type: 'Person', record_id: @person.id, controller_name: 'person', action_name: 'destroy')
      redirect_to people_url, notice: "Person was successfully destroyed."
    rescue StandardError => e
      redirect_to people_url, alert: "Object could not be deleted because it's being used somewhere else in the system"
    end
  end

  private
  def set_person
    @person = Person.find(params[:id])
  end

  def person_params
    params.require(:person).permit(:writing_system_id, :prefix_vernacular, :suffix_vernacular, :first_name_vernacular, :middle_name_vernacular, :last_name_vernacular, :prefix_transliteration, :suffix_transliteration, :first_name_transliteration, :middle_name_transliteration, :last_name_transliteration, :prefix_english, :suffix_english, :first_name_english, :middle_name_english, :last_name_english, :birth_date, :death_date, :character, :viaf, :birth_date_exact, :death_date_exact)
  end
end
