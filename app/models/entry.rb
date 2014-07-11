class Entry < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  belongs_to :entity, :class_name => 'Entity', :foreign_key => 'entity_id'
  
  has_many :field_instances, :class_name => 'FieldInstance', :foreign_key => 'entry_id' 
  has_many :entity_instances, :class_name => 'EntityInstance', :foreign_key => 'entry_id'  
  
  accepts_nested_attributes_for :field_instances, allow_destroy: true
  accepts_nested_attributes_for :entity_instances, allow_destroy: true
end
