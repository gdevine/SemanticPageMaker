class Entity < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  
  has_many :entity_fields, :dependent => :destroy
  has_many :fields, :through => :entity_fields, :dependent => :destroy
  accepts_nested_attributes_for :entity_fields, :reject_if => proc { |a| a['field_id'].blank? }, allow_destroy: true
  
  has_many :links
  has_many :entities, :through => :links
  accepts_nested_attributes_for :links, :reject_if => proc { |a| a['link_id'].blank? }, allow_destroy: true
  
  default_scope -> { order('name ASC') }
  
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :creator_id, presence: true
end
