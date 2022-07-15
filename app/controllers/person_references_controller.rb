class PersonReferencesController < ApplicationController
  before_action :set_person_reference, only: %i[ show edit update destroy ]
  # skip_before_action :authenticate_user!, only: %i[ index ]
  before_action :allow_for_editor, only: %i[ index edit update destroy create ]

  def index
    @person_references = PersonReference.all
  end

  def show
  end

  def new
    @person_reference = PersonReference.new
  end

  def edit
  end

  def create
    @person_reference = PersonReference.new(person_reference_params)

    if @person_reference.save
      redirect_to person_references_url, notice: "Person reference was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @person_reference.update(person_reference_params)
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_to person_references_url, notice: "Person reference was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @person_reference.destroy
    redirect_to person_references_url, notice: "Person reference was successfully destroyed."
  end

  private
    def set_person_reference
      @person_reference = PersonReference.find(params[:id])
    end

    def person_reference_params
      params.require(:person_reference).permit(:record_id, :person_id)
    end
end
