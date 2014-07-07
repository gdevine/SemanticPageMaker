class CreateEntityInstances < ActiveRecord::Migration
  def change
    create_table :entity_instances do |t|
      t.integer :entry_id
      t.integer :link_id
      t.string :exposeAs

      t.timestamps
    end
  end
end
