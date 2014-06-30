class AddPropertyToFields < ActiveRecord::Migration
  def change
    add_column :fields, :property, :string
  end
end
