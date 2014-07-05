class CreateFieldInstances < ActiveRecord::Migration
  def change
    create_table :field_instances do |t|
      t.integer :creator_id
      t.integer :entry_id
      t.integer :field_id
      t.string :answer

      t.timestamps
    end
  end
end
