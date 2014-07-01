class EntryController < ApplicationController
  
  def new
    @entry = Entry.new
  end
end
