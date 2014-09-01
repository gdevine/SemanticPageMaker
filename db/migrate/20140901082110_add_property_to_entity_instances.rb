class AddPropertyToEntityInstances < ActiveRecord::Migration
  def change
    add_column :entity_instances, :property, :string
  end
end
