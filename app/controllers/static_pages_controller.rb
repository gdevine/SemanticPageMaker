class StaticPagesController < ApplicationController
  before_action :signed_in_user, only: [:dashboard]
  
  def home
    @entities = Entity.all
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
  
  def dashboard
    @entities = Entity.all
  end
  
end
