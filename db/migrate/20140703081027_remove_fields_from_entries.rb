class RemoveFieldsFromEntries < ActiveRecord::Migration
  def change
    remove_column :entries, :entities_collection, :integer
    remove_column :entries, :fields_collection, :integer
  end
end
