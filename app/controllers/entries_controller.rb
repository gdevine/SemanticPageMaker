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
    @entry.field_instances.build
    @entry.entity_instances.build
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
    
    @fieldlist = []
    for efield in @entry.field_instances
      myhash = Hash.new
      myhash['label'] = efield.exposeAs
      myhash['predicate'] = (Field.find(efield.field_id)).property
      myhash['answer'] = efield.answer
      @fieldlist << myhash 
    end
    
    @entitylist = []
    for ent in @entry.entity_instances
      myhash = Hash.new
      myhash['label'] = ent.exposeAs
      # myhash['predicate'] = (Field.find(efield.field_id)).property
      myhash['answer'] = ent
      @entitylist << myhash 
    end
    @entity = Entity.find(@entry.entity_id)
    @entities = Entity.all
  end
  
  
  private
  
    def entry_params
      params.require(:entry).permit(:entity_id, 
                                    :entry_id, 
                                    :field_id, 
                                    field_instances_attributes: [:entry_id, :field_id, :exposeAs, :answer],
                                    entity_instances_attributes: [:entry_id, :link_id, :exposeAs])
    end
    
    def correct_user
      @entry = current_user.entries.find_by(id: params[:id])
      redirect_to root_url if @entry.nil?
    end
end
