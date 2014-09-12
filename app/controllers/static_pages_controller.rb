class StaticPagesController < ApplicationController
  before_action :signed_in_user, only: [:dashboard]
  
  def home
    @entities = Entity.all
  end

  def help
    @entities = Entity.all
  end
  
  def about
    @entities = Entity.all
  end
  
  def contact
    @entities = Entity.all
  end
  
  def dashboard
    @entities = Entity.all
  end
  
end
