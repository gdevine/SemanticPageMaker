class Entry < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  belongs_to :entity, :class_name => 'Entity', :foreign_key => 'entity_id'
end
