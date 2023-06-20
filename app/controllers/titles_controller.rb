class TitlesController < ApplicationController
  before_action :set_title, only: %i[ show edit update destroy make_apocryphal ]
  skip_before_action :authenticate_user!, only: %i[ index ]
  before_action :allow_for_editor, only: %i[ edit update destroy create create_from_content]

  def index
    @titles = Title.all
    @initial_state = current_user.user_grid_states.find_by(record_type: "Title").try(:state).try(:to_json).try(:html_safe)
    @initial_filter = current_user.user_grid_states.find_by(record_type: "Title").try(:filters).try(:to_json).try(:html_safe)
  end

  def show
    if request.xhr?
      render json: {title: @title}
    end
  end

  def new
    @title = Title.new
    @from = request.path
  end

  def edit
  end

  def create
    @title = Title.new(title_params)

    saved = @title.save

    if params[:content_id].present?
      Content.find(params[:content_id]).update(title_id: @title.id)
    end

    if saved
      ChangeLog.create(user_id: current_user.id, record_type: 'Title', record_id: @title.id, controller_name: 'title', action_name: 'create')
      ta = @title.apocryphon
      if ta.present? && params[:title][:is_standard] == "true" && @title.try(:language_id) == helpers.english_id
          ta.update(main_english_title_id: @title.id)
      elsif ta.present? && params[:title][:is_standard] == "true" &&  @title.try(:language_id) == helpers.latin_id
        ta.update(main_latin_title_id: @title.id)
      end
      if ta.present? && ta.content_id.present?
        Content.find(ta.content_id).update(title_id: @title.id)
        ta.update(content_id: nil)
      end
      if request.xhr?
        render :json => {"status": "updated"}  
      else
        redirect_path = @title.apocryphon_id.present? ? edit_apocryphon_path(@title.apocryphon_id, old_path: params[:old_path]) : titles_path
        redirect_to redirect_path, notice: "Title was successfully created."
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create_from_content
    puts params.inspect.red
    @title = Title.new(title_params)

    if @title.save
      ChangeLog.create(user_id: current_user.id, record_type: 'Title', record_id: @title.id, controller_name: 'title', action_name: 'create_from_content')
      if params[:content_id].present?
        Content.find(params[:content_id]).update(title_id: @title.id)
      elsif params[:parent_type].present? && params[:parent_id].present?
        parent = params[:parent_type].constantize.find(params[:parent_id])
        parent.contents.create(title_id: @title.id, sequence_no: parent.contents.count+1)
      end
      redirect_path = @title.apocryphon_id.present? ? edit_apocryphon_path(@title.apocryphon_id, old_path: params[:from]) : edit_title_path(@title, old_path: params[:from])
      redirect_to redirect_path, notice: "Title was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @title.update(title_params)
      ChangeLog.create(user_id: current_user.id, record_type: 'Title', record_id: @title.id, controller_name: 'title', action_name: 'update')
      if request.xhr?
        render :json => {id: @title.id}  
      else
        if params[:old_path].present?
          redirect_to params[:old_path], notice: "Title was successfully updated."
        else
          redirect_to titles_url, notice: "Title was successfully updated."
        end
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @title.destroy
    ChangeLog.create(user_id: current_user.id, record_type: 'Title', record_id: @title.id, controller_name: 'title', action_name: 'destroy')
    if request.xhr?
      render :json => {"status": "updated"}  
    else
      redirect_to titles_url, notice: "Title was successfully destroyed."
    end
  end

  def make_apocryphal
    apocryphon = Apocryphon.create(main_latin_title_id: @title.id)
    @title.update(apocryphon_id: apocryphon.id)
    redirect_to edit_apocryphon_path(apocryphon)
  end

  private
    def set_title
      @title = Title.find(params[:id] || params[:title_id])
    end

    def title_params
      params.require(:title).permit(:apocryphon_id, :title_orig, :title_orig_transliteration, :title_translation, :language_id, :abbreviation, :italicized)
    end
end
