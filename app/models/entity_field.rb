class EntityField < ActiveRecord::Base
  belongs_to :entity
  belongs_to :field
  accepts_nested_attributes_for :field, :allow_destroy=>true
end
