class RemoveFieldIdFromEntries < ActiveRecord::Migration
  def change
    remove_column :entries, :field_id, :integer
  end
end
