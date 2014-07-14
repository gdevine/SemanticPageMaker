class EntitiesController < ApplicationController
  before_action :signed_in_user, only: [:index, :new, :show, :update, :edit, :create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def index   
    @entities = Entity.paginate(page: params[:page])
  end
  
  def new
    @entity = Entity.new
    @entity.entity_fields.build.build_field
    @entity.links.build.build_entity
    @entities = Entity.all
  end
  
  def show
    @entity = Entity.find(params[:id])
    # Get my fields
    @fieldlist = []
    if !@entity.entity_fields.empty?
      for efield in @entity.entity_fields
        myhash = Hash.new
        myhash['id'] = (Field.find(efield.field_id)).id
        myhash['name'] = (Field.find(efield.field_id)).name
        myhash['exposeAs'] = efield.exposeAs
        myhash['fieldtype'] = (Field.find(efield.field_id)).fieldtype
        @fieldlist << myhash 
      end
    end
    # Get my linked entitys
    @linklist = []
    if !@entity.links.empty?
      for link in @entity.links
        myhash = Hash.new
        myhash['id'] = (Entity.find(link.link_id)).id
        myhash['name'] = (Entity.find(link.link_id)).name
        myhash['exposeAs'] = link.exposeAs
        @linklist << myhash 
      end
    end
    
    @entities = Entity.all
  end
  
  def create
    @entity = current_user.entities.build(entity_params)
    @entities = Entity.all
    if @entity.save
      flash[:success] = "Entity created!"
      redirect_to @entity
    else
      render 'new'
    end
  end
  
  def edit
    @entity = Entity.find(params[:id])
    @entities = Entity.all
  end
     
  def update
    @entity = Entity.find(params[:id])
    if @entity.update_attributes(entity_params)
      flash[:success] = "Entity updated"
      redirect_to @entity
    else
      render 'edit'
    end
  end

  def destroy
    @entity.destroy
    redirect_to entities_path
  end
  
  
  private

    def entity_params
      params.require(:entity).permit(:name, 
                                     :exposeAs, 
                                     :freetext, 
                                     :typeof,
                                     entity_fields_attributes: [:id, :multiple, :entity_id, :field_id, :exposeAs, :_destroy],
                                     links_attributes: [:id, :multiple, :entity_id, :link_id, :exposeAs, :property, :_destroy])
    end
    
    def correct_user
      @entity = current_user.entities.find_by(id: params[:id])
      redirect_to root_url if @entity.nil?
    end
  
end