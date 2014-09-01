class AddPropertyToLinks < ActiveRecord::Migration
  def change
    add_column :links, :property, :string
  end
end
