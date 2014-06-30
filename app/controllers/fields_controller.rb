class FieldsController < ApplicationController
  before_action :signed_in_user, only: [:index, :new, :show, :update, :edit, :create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def index   
    @fields = Field.paginate(page: params[:page])
  end
  
  def new
    @field = Field.new
  end
  
  def show
    @field = Field.find(params[:id])
  end
  
  def create
    @field = current_user.fields.build(field_params)
    if @field.save
      flash[:success] = "Field created!"
      redirect_to @field
    else
      render 'new'
    end
  end
  
   def edit
    @field = Field.find(params[:id])
  end
     
  def update
    @field = Field.find(params[:id])
    if @field.update_attributes(field_params)
      flash[:success] = "Field updated"
      redirect_to @field
    else
      render 'edit'
    end
  end

  def destroy
    @field.destroy
    redirect_to fields_path
  end
  
  private

    def field_params
      params.require(:field).permit(:name, :property)
    end
    
    def correct_user
      @field = current_user.fields.find_by(id: params[:id])
      redirect_to root_url if @field.nil?
    end
end
