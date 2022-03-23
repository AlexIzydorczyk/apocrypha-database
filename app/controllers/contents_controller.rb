class ContentsController < ApplicationController
  before_action :set_content, only: %i[ show edit update destroy create_text ]
  skip_before_action :authenticate_user!, only: %i[ index ]
  before_action :allow_for_editor, only: %i[ edit update destroy create move_to_booklet sort create_text ]

  def index
    @contents = Content.all
  end

  def show
  end

  def new
    @content = Content.new
  end

  def edit
    @content.update(has_details: true) unless @content.has_details
  end

  def create
    @content = Content.new(content_params)
    @content.sequence_no = @content.parent.contents.count+1

    if @content.save
      ChangeLog.create(user_id: current_user.id, record_type: 'Content', record_id: @content.id, controller_name: 'content', action_name: 'create')
      render :json => { new_url: content_path(@content), id: @content.id }
      # redirect_to contents_url, notice: "Content was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @content.update(content_params)
      if request.xhr?
        render :json => { new_url: content_path(@content), id: @content.id }
      else
        redirect_path = params[:moved_to_booklet] ? edit_manuscript_path(@content.booklet.manuscript) : contents_path
        notice = params[:moved_to_booklet] ? "Content was successfully moved to booklet." : "Content was successfully updated."
        redirect_to redirect_path, notice: notice
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def move_to_booklet
    content = Content.find(params[:id])
    if params[:booklets]
      if params[:booklets].length > 0
        content.update(booklet_id: Booklet.find(params[:booklets][0]).id, manuscript_id: nil)
      end
      if params[:booklets].length > 1
        params[:booklets][1..-1].each do |b_id|
          new_c = content.dup
          new_c.booklet_id = b_id
          new_c.manuscript_id = nil
          new_c.save
        end 
      end
    end
    redirect_to edit_manuscript_path(content.booklet.manuscript)
  end

  def destroy
    @content.destroy
    if request.xhr?
      render :json => {"status": "updated"}  
    else
      redirect_to booklist_sections_url, notice: "Booklist section was successfully destroyed."
    end
  end

  def sort
    params[:content].each_with_index do |id, index|
      Content.where(id: id).update_all(sequence_no: index + 1)
    end
  end

  private
    def set_content
      @content = Content.find(params[:id])
    end

    def content_params
      params.require(:content).permit(:booklet_id, :sequence_no, :title_id, :author_id, :manuscript_id)
    end
end
