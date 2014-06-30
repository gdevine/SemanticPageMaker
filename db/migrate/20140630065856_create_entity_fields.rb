class CreateEntityFields < ActiveRecord::Migration
  def change
    create_table :entity_fields do |t|
      t.string :multiple
      t.string :exposeAs
      t.string :string

      t.timestamps
    end
  end
end
