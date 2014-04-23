class AddCreatorIdToEntities < ActiveRecord::Migration
  def change
    add_column :entities, :creator_id, :integer
  end
end
