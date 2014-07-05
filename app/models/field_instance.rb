class FieldInstance < ActiveRecord::Base
  
  belongs_to :entry, :class_name => 'Entry', :foreign_key => 'entry_id'
end
