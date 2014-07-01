class RemoveStringFromEntityFields < ActiveRecord::Migration
  def change
    remove_column :entity_fields, :string, :string
  end
end
