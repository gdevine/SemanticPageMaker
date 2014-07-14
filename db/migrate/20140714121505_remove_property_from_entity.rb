class RemovePropertyFromEntity < ActiveRecord::Migration
  def change
    remove_column :entities, :property, :string
  end
end
