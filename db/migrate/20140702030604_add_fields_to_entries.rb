class AddFieldsToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :entities_collection, :integer
    add_column :entries, :fields_collection, :integer
  end
end
