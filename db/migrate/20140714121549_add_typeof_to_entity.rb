class AddTypeofToEntity < ActiveRecord::Migration
  def change
    add_column :entities, :typeof, :string
  end
end
