class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.integer :entity_id
      t.integer :link_id
      t.boolean :multiple
      t.string :exposeAs

      t.timestamps
    end
  end
end
