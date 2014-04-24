class EntitiesController < ApplicationController
  before_action :signed_in_user, only: [:index, :new, :show, :update, :edit, :create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def index   
    @entities = Entity.paginate(page: params[:page])
  end
  
  def new
    @entity = Entity.new
  end
  
  def show
    @entity = Entity.find(params[:id])
  end
  
  def create
    # @entity = Entity.new(entity_params)
    @entity = current_user.entities.build(entity_params)
    if @entity.save
      flash[:success] = "Entity created!"
      redirect_to @entity
    else
      render 'new'
    end
  end
  
   def edit
    @entity = Entity.find(params[:id])
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
      params.require(:entity).permit(:name, :exposeAs, :freetext)
    end
    
    def correct_user
      @entity = current_user.entities.find_by(id: params[:id])
      redirect_to root_url if @entity.nil?
    end
  
end