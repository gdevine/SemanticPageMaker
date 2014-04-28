class AddCreatorIdToFields < ActiveRecord::Migration
  def change
    add_column :fields, :creator_id, :integer
  end
end
