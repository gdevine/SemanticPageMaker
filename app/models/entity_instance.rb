class EntityInstance < ActiveRecord::Base
  belongs_to :entry, :class_name => 'Entry', :foreign_key => 'entry_id'
  belongs_to :entry, :class_name => 'Entry', :foreign_key => 'link_id'
end
