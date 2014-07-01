class Entry < ActiveRecord::Base
  belongs_to :entity
  belongs_to :field
end
