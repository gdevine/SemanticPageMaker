class AddCreatorIdToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :creator_id, :integer
  end
end
