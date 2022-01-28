class PeopleController < ApplicationController
  before_action :set_person, only: %i[ show edit update destroy ]

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
      PersonReference.create(record: Booklet.find(params[:booklet_id]), person: @person)
    elsif params[:ownership_id].present?
      Ownership.find(params[:ownership_id]).update(person_id: @person.id)
    end
    if saved && !request.xhr?
      # redirect_path = params[:booklet_id].present? ? edit_manuscript_booklet_path(Booklet.find(params[:booklet_id]).manuscript, params[:booklet_id]) : people_path
      # redirect_to redirect_path, notice: "Person was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end


  def update
    if @person.update(person_params)
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
    @person.destroy
    redirect_to people_url, notice: "Person was successfully destroyed."
  end

  private
  def set_person
    @person = Person.find(params[:id])
  end

  def person_params
    params.require(:person).permit(:language_id, :prefix_vernacular, :suffix_vernacular, :first_name_vernacular, :middle_name_vernacular, :last_name_vernacular, :prefix_transliteration, :suffix_transliteration, :first_name_transliteration, :middle_name_transliteration, :last_name_transliteration, :prefix_english, :suffix_english, :first_name_english, :middle_name_english, :last_name_english, :birth_date, :death_date, :character, :viaf)
  end
end
