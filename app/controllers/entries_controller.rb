class EntriesController < ApplicationController
  before_action :signed_in_user, only: [:new, :update, :edit, :create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def index        
    # Index returns entries broken down by entity type     
      
    @entries = Entry.paginate(page: params[:page])
    
    # create array to track already found entity types
    entities_completed = entity_entries = []
    # retrieve all entries
    all_entries = Entry.all
    # create a master array to contain all sorted entries
    @sorted_entries = []
    all_entries.each do |entry|
      my_entity_type = Entity.find(entry.entity_id).name
      if !entities_completed.include?(my_entity_type)
        # entity type has not been found as of yet so create a new hash
        entity_collection = {"entity_type" => my_entity_type, "entries" => []}
        # create a mini hash for this entry
        entry_hash = {"slug" => entry.slug, "url" => entry_path(entry.id)}
        # add entry mini hash to entity_collection
        entity_collection["entries"] << entry_hash 
        # add me as a new member of the sorted_entries master array
        @sorted_entries << entity_collection
        # add entity type to those found already (so that future instance are added to this one)
        entities_completed << my_entity_type
      else
        # retrieve the matching existing entity_collection
        entity_collection = @sorted_entries.find {|collection| collection["entity_type"] == my_entity_type }
        # create a mini hash for this entry
        entry_hash = {"slug" => entry.slug, "url" => entry_path(entry.id)}
        # add entry mini hash to entity_collection
        entity_collection["entries"] << entry_hash          
      end
        
    end
      
    @entities = Entity.all
  end
  
  def new
    @entry = Entry.new
    # send the related entity into the view also
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
      # Still need to include the entity type for rendering back to a new entry
      @entity = Entity.find(@entry.entity_id)
      # All entities needed for the menu bar (temporary placement)
      @entities = Entity.all
      
      render 'new'
    end
  end
  
  def edit
    @entry = Entry.find(params[:id])
    @entity = Entity.find(params[:entity_id])
    @entities = Entity.all
  end
  
  def update
    @entry = Entry.find(params[:id])
    if @entry.update_attributes(entry_params)
      flash[:success] = "Entry updated"
      redirect_to @entry
    else
      # Still need to include the entity type for rendering back to a new entry
      @entity = Entity.find(@entry.entity_id)
      # All entities needed for the menu bar (temporary placement)
      @entities = Entity.all
      
      render 'edit'
    end
  end
  
  def show
    @entry = Entry.find(params[:id])
    
    @fieldlist = []
    if !@entry.field_instances.empty?
      for efield in @entry.field_instances
        myhash = Hash.new
        myhash['label'] = efield.exposeAs
        myhash['predicate'] = (Field.find(efield.field_id)).property
        myhash['answer'] = efield.answer
        @fieldlist << myhash 
      end
    end
      
    @entitylist = []
    if !@entry.entity_instances.empty?
      for ent in @entry.entity_instances
        myhash = Hash.new
        myhash['label'] = ent.exposeAs
        # myhash['property'] = ent.property
        myhash['predicate'] = ent.property
        myhash['answer'] = ent
        @entitylist << myhash 
      end
    end
    
    @entity = Entity.find(@entry.entity_id)
    @entities = Entity.all
    
    render :layout => 'entry_layout'
  end
  
  def destroy
    @entry.destroy
    redirect_to entries_path
  end
  
  private
  
    def entry_params
      params.require(:entry).permit(:entity_id, 
                                    :entry_id, 
                                    :field_id, 
                                    :textblock,
                                    :slug,
                                    field_instances_attributes: [:id, :entry_id, :field_id, :exposeAs, :answer, :_destroy],
                                    entity_instances_attributes: [:id, :entry_id, :link_id, :exposeAs, :property, :_destroy])
    end
    
    def correct_user
      @entry = current_user.entries.find_by(id: params[:id])
      redirect_to root_url if @entry.nil?
    end
end
