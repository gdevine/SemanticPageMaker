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
    
    # create a master array to contain all grouped fields
    @grouped_fields = []    
    # create array to track already found field types
    fields_found = []
    
    if !@entry.field_instances.empty?
      for efield in @entry.field_instances
        
        if !fields_found.include?(efield.exposeAs)
          # field type has not been found as of yet so create a new hash
          field_list = {"label" => efield.exposeAs, "predicate" => (Field.find(efield.field_id)).property, "answers" => []}
          # add current answer to this grouping
          field_list["answers"] << efield.answer
          # add me as a new member of the grouped_fields master array
          @grouped_fields << field_list
          # add field type to those found already (so that future instance are added to this one)
          fields_found << efield.exposeAs
        else
          # retrieve the matching existing field_list
          field_list = @grouped_fields.find {|grouping| grouping["label"] == efield.exposeAs }
          # add entry mini hash to the collection
          field_list["answers"] << efield.answer          
        end
        
      end
    end
    
    # create a master array to contain all grouped entities
    @grouped_entities = []    
    # create array to track already found field types
    entities_found = []
      
    if !@entry.entity_instances.empty?
      for ent in @entry.entity_instances
        
        if !entities_found.include?(ent.exposeAs)
          # entity type has not been found as of yet so create a new hash
          entity_list = {"label" => ent.exposeAs, "predicate" => ent.property, "answers" => []}
          # add current answer to this grouping
          entity_list["answers"] << ent.link_id
          # add me as a new member of the grouped_entities master array
          @grouped_entities << entity_list
          # add entity type to those found already (so that future instance are added to this one)
          entities_found << ent.exposeAs
        else
          # retrieve the matching existing entity_list
          entity_list = @grouped_entities.find {|grouping| grouping["label"] == ent.exposeAs }
          # add entry mini hash to the collection
          entity_list["answers"] << ent.link_id 
        end
        
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
