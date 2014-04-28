class Field < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  default_scope -> { order('name ASC') }
  
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :creator_id, presence: true
end



