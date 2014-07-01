class AddIdsToEntityFields < ActiveRecord::Migration
  def change
    add_column :entity_fields, :entity_id, :integer
    add_column :entity_fields, :field_id, :integer
  end
end
