class CreateEntities < ActiveRecord::Migration
  def change
    create_table :entities do |t|
      t.string :name
      t.string :exposeAs
      t.boolean :freetext

      t.timestamps
    end
  end
end