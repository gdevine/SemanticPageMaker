class RemoveTypeFromFields < ActiveRecord::Migration
  def change
    remove_column :fields, :type, :string
  end
end
