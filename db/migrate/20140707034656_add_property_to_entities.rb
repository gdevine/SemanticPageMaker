class AddPropertyToEntities < ActiveRecord::Migration
  def change
    add_column :entities, :property, :string
  end
end
