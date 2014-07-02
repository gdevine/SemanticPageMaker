class EntriesController < ApplicationController
  before_action :signed_in_user, only: [:index, :new, :show, :update, :edit, :create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def index   
    @entries = Entry.paginate(page: params[:page])
    @entities = Entity.all
  end
  
  def new
    @entry = Entry.new
    @entity = Entity.find(params[:entity_id])
    @entities = Entity.all
  end
  
  def create
    @entry = current_user.entries.build(entry_params)
    if @entry.save
      flash[:success] = "Entry created!"
      redirect_to @entry
    else
      render 'new'
    end
  end
  
  def show
    @entry = Entry.find(params[:id])
    @entity = Entity.find(@entry.entity_id)
    @entities = Entity.all
  end
  
  
  private
  
    def entry_params
      params.require(:entry).permit(:entity_id, 
                                     :fields_collection, 
                                     :entities_collection)
    end
    
    def correct_user
      @entry = current_user.entries.find_by(id: params[:id])
      redirect_to root_url if @entry.nil?
    end
end
