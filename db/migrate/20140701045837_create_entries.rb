class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :entity_id
      t.integer :field_id
      t.string :answer

      t.timestamps
    end
  end
end
